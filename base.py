"""Shared helpers: a tool-calling LangGraph agent builder and a safe sympy parser."""
import os

import sympy
from dotenv import load_dotenv
from langchain.chat_models import init_chat_model
from langchain.messages import SystemMessage, ToolMessage
from langgraph.graph import END, START, MessagesState, StateGraph
from sympy.parsing.sympy_parser import (
    convert_xor,
    implicit_multiplication_application,
    parse_expr,
    standard_transformations,
)
from typing_extensions import Literal

load_dotenv()

# Override with e.g. MODEL_PROVIDER=anthropic MODEL_NAME=claude-sonnet-5-5
MODEL_PROVIDER = os.getenv("MODEL_PROVIDER", "openai")
MODEL_NAME = os.getenv("MODEL_NAME", "gpt-6-luna")

_TRANSFORMS = standard_transformations + (implicit_multiplication_application, convert_xor)
# Only sympy names are visible to parsed input; no Python builtins.
_NAMESPACE = {k: v for k, v in vars(sympy).items() if not k.startswith("_")}
_NAMESPACE["__builtins__"] = {}


def parse(text: str) -> sympy.Expr:
    """Parse a math string (e.g. '3x^2 + sin(x)') into a sympy expression."""
    return parse_expr(text, global_dict=dict(_NAMESPACE), transformations=_TRANSFORMS)


def per_input(items: list[str], fn) -> str:
    """Apply fn to each input; report each result or error on its own line."""
    lines = []
    for item in items:
        try:
            lines.append(f"{item}  ->  {fn(item)}")
        except Exception as exc:  # one bad input shouldn't sink the batch
            lines.append(f"{item}  ->  ERROR: {exc}")
    return "\n".join(lines)


def build_agent(tools: list, system_prompt: str):
    """Compile a Graph API agent: llm_call <-> tool_node until no tool calls remain."""
    model = init_chat_model(MODEL_NAME, model_provider=MODEL_PROVIDER)
    model_with_tools = model.bind_tools(tools)
    tools_by_name = {t.name: t for t in tools}

    def llm_call(state: MessagesState):
        response = model_with_tools.invoke([SystemMessage(content=system_prompt)] + state["messages"])
        return {"messages": [response]}

    def tool_node(state: MessagesState):
        results = []
        for call in state["messages"][-1].tool_calls:
            observation = tools_by_name[call["name"]].invoke(call["args"])
            results.append(ToolMessage(content=str(observation), tool_call_id=call["id"]))
        return {"messages": results}

    def should_continue(state: MessagesState) -> Literal["tool_node", "__end__"]:
        return "tool_node" if state["messages"][-1].tool_calls else END

    builder = StateGraph(MessagesState)
    builder.add_node("llm_call", llm_call)
    builder.add_node("tool_node", tool_node)
    builder.add_edge(START, "llm_call")
    builder.add_conditional_edges("llm_call", should_continue, ["tool_node", END])
    builder.add_edge("tool_node", "llm_call")
    return builder.compile()
