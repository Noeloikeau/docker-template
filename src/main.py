"""Simple example module."""
from typing import Union


def add_numbers(a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
    """Add two numbers together."""
    return a + b


if __name__ == "__main__":  # pragma: no cover
    result = add_numbers(1, 2)
    print(f"Test result: {result}")
