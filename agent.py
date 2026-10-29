"""Calculator agent built with the LangGraph Graph API.

Written from the standard Graph API agent pattern (not the fetched quickstart,
which was unreachable) -- compare against the quickstart when it is accessible.
"""
from dotenv import load_dotenv
from langchain.chat_models import init_chat_model
from langchain.messages import AnyMessage, HumanMessage, SystemMessage, ToolMessage
from langchain.tools import tool
from langgraph.graph import END, START, MessagesState, StateGraph
from typing_extensions import Literal

load_dotenv()

model = init_chat_model("claude-sonnet-5-5", model_provider="anthropic", temperature=0)


@tool
def add(a: int, b: int) -> int:
    """Add `a` and `b`."""
    return a + b


@tool
def multiply(a: int, b: int) -> int:
    """Multiply `a` and `b`."""
    return a * b


@tool
def divide(a: int, b: int) -> float:
    """Divide `a` by `b`."""
    return a / b


tools = [add, multiply, divide]
tools_by_name = {t.name: t for t in tools}
model_with_tools = model.bind_tools(tools)


def llm_call(state: MessagesState):
    """LLM decides whether to call a tool or answer."""
    response = model_with_tools.invoke(
        [SystemMessage(content="You are a helpful assistant that performs arithmetic on inputs.")]
        + state["messages"]
    )
    return {"messages": [response]}


def tool_node(state: MessagesState):
    """Execute the tool calls requested by the last AI message."""
    results = []
    for call in state["messages"][-1].tool_calls:
        observation = tools_by_name[call["name"]].invoke(call["args"])
        results.append(ToolMessage(content=str(observation), tool_call_id=call["id"]))
    return {"messages": results}


def should_continue(state: MessagesState) -> Literal["tool_node", "__end__"]:
    """Route to the tool node if the LLM made tool calls, otherwise finish."""
    return "tool_node" if state["messages"][-1].tool_calls else END


builder = StateGraph(MessagesState)
builder.add_node("llm_call", llm_call)
builder.add_node("tool_node", tool_node)
builder.add_edge(START, "llm_call")
builder.add_conditional_edges("llm_call", should_continue, ["tool_node", END])
builder.add_edge("tool_node", "llm_call")
agent = builder.compile()


if __name__ == "__main__":
    result = agent.invoke({"messages": [HumanMessage(content="Add 3 and 4, multiply the result by 6, then divide by 2.")]})
    for m in result["messages"]:
        m.pretty_print()
    print("\nFinal answer:", result["messages"][-1].content)
