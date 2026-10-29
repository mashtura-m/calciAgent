"""Calculus subagent: differentiation and integration over one or many inputs."""
import sympy as sp
from langchain.tools import tool

from base import build_agent, parse, per_input

SYSTEM_PROMPT = (
    "You are a calculus specialist. Use the tools for every derivative and integral; "
    "pass all expressions from the request in a single call when they share a variable. "
    "Write expressions with ^ for powers and explicit function names (sin, exp, log). "
    "Report each input with its result, and say clearly if an input could not be solved."
)


@tool
def differentiate(expressions: list[str], variable: str = "x", order: int = 1) -> str:
    """Differentiate each expression with respect to `variable`, `order` times."""
    v = sp.Symbol(variable)
    return per_input(expressions, lambda e: sp.diff(parse(e), v, order))


@tool
def integrate_indefinite(expressions: list[str], variable: str = "x") -> str:
    """Indefinite integral (antiderivative, without + C) of each expression."""
    v = sp.Symbol(variable)
    return per_input(expressions, lambda e: sp.integrate(parse(e), v))


@tool
def integrate_definite(expressions: list[str], lower: str, upper: str, variable: str = "x") -> str:
    """Definite integral of each expression from `lower` to `upper` (e.g. '0', 'pi', 'oo')."""
    v = sp.Symbol(variable)
    lo, hi = parse(lower), parse(upper)

    def run(e):
        result = sp.integrate(parse(e), (v, lo, hi))
        return f"{result}  (~ {sp.N(result)})"

    return per_input(expressions, run)


tools = [differentiate, integrate_indefinite, integrate_definite]


def make_agent():
    return build_agent(tools, SYSTEM_PROMPT)
