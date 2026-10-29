"""Trigonometry subagent: evaluate, simplify, verify identities, solve equations."""
import sympy as sp
from langchain.tools import tool

from base import build_agent, parse, per_input

SYSTEM_PROMPT = (
    "You are a trigonometry specialist. Use the tools for every evaluation, simplification, "
    "identity check, and equation solve; pass all inputs in a single call when possible. "
    "Angles are in radians unless a tool says degrees. Show exact forms where available, "
    "and say clearly if an input could not be solved."
)


@tool
def evaluate_trig(expressions: list[str], degrees: bool = False) -> str:
    """Evaluate trig expressions exactly and numerically. Set degrees=True if angles in the input are degrees."""

    def run(e):
        expr = parse(e)
        if degrees:
            expr = expr.replace(lambda a: a.func in (sp.sin, sp.cos, sp.tan, sp.cot, sp.sec, sp.csc),
                                lambda a: a.func(a.args[0] * sp.pi / 180))
        exact = sp.simplify(expr)
        return f"{exact}  (~ {sp.N(exact)})"

    return per_input(expressions, run)


@tool
def simplify_trig(expressions: list[str]) -> str:
    """Simplify trigonometric expressions using identities."""
    return per_input(expressions, lambda e: sp.trigsimp(parse(e)))


@tool
def check_identity(pairs: list[str]) -> str:
    """Check identities. Each item is 'lhs = rhs' (e.g. 'sin(x)^2 + cos(x)^2 = 1')."""

    def run(p):
        lhs, rhs = p.split("=", 1)
        diff = sp.simplify(parse(lhs) - parse(rhs))
        if diff == 0:
            return "TRUE (identity holds)"
        # simplify can miss equivalences; fall back to numeric spot checks
        syms = sorted(diff.free_symbols, key=str)
        pts = [{s: sp.Rational(k + 1, 7) for s in syms} for k in range(3)]
        holds = all(abs(sp.N(diff.subs(pt))) < 1e-9 for pt in pts)
        return "LIKELY TRUE (numeric check only)" if holds else f"FALSE (difference = {diff})"

    return per_input(pairs, run)


@tool
def solve_trig_equation(equations: list[str], variable: str = "x") -> str:
    """Solve each equation (given as 'lhs = rhs' or an expression equal to 0) for `variable`.

    Returns solutions in [0, 2*pi) plus the general solution set when available."""
    v = sp.Symbol(variable, real=True)

    def run(eq):
        if "=" in eq:
            lhs, rhs = eq.split("=", 1)
            expr = parse(lhs) - parse(rhs)
        else:
            expr = parse(eq)
        expr = expr.subs(sp.Symbol(variable), v)
        principal = sp.solveset(expr, v, sp.Interval.Ropen(0, 2 * sp.pi))
        general = sp.solveset(expr, v, sp.S.Reals)
        return f"in [0, 2pi): {principal};  general: {general}"

    return per_input(equations, run)


tools = [evaluate_trig, simplify_trig, check_identity, solve_trig_equation]


def make_agent():
    return build_agent(tools, SYSTEM_PROMPT)
