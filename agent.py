"""Main calculator agent (LangGraph Graph API).

Handles arithmetic itself and delegates to two subagents:
  - calculus_agent: differentiation / integration over multiple inputs
  - trig_agent: trigonometry evaluation, simplification, identities, equations

Written from the standard Graph API agent pattern (not the fetched quickstart,
which was unreachable) -- compare against the quickstart when it is accessible.
"""
from langchain.messages import HumanMessage
from langchain.tools import tool

import calculus_agent
import trig_agent
from base import build_agent

SYSTEM_PROMPT = (
    "You are a helpful calculator assistant. Use add/multiply/divide for arithmetic. "
    "Delegate calculus (derivatives, integrals) to ask_calculus_agent and trigonometry "
    "to ask_trig_agent, passing the full request including all inputs. "
    "Combine the results into one clear answer."
)


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


def _delegate(subagent, request: str) -> str:
    result = subagent.invoke({"messages": [HumanMessage(content=request)]})
    content = result["messages"][-1].content
    if isinstance(content, list):  # content blocks -> plain text
        content = "".join(b.get("text", "") for b in content if isinstance(b, dict))
    return content


@tool
def ask_calculus_agent(request: str) -> str:
    """Delegate differentiation or integration (one or many expressions) to the calculus subagent."""
    return _delegate(calculus_agent.make_agent(), request)


@tool
def ask_trig_agent(request: str) -> str:
    """Delegate trigonometry (evaluate, simplify, verify identities, solve equations) to the trig subagent."""
    return _delegate(trig_agent.make_agent(), request)


agent = build_agent([add, multiply, divide, ask_calculus_agent, ask_trig_agent], SYSTEM_PROMPT)


if __name__ == "__main__":
    prompt = (
        "Add 3 and 4, multiply the result by 6, then divide by 2. "
        "Also differentiate x^3, sin(x)*x and exp(2x), integrate x^2 from 0 to 3, "
        "and solve 2*sin(x) = 1."
    )
    result = agent.invoke({"messages": [HumanMessage(content=prompt)]})
    for m in result["messages"]:
        m.pretty_print()
