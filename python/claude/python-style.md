# Python Style Guide

## Standards
- Follow PEP 8 for all code style decisions.
- Place all imports at the top of the file, grouped in this order: standard library,
  third-party, local. Separate each group with a blank line.

## Imports
- Do not import classes, functions, or exceptions directly from any module. Always import
  the nearest containing module instead. This applies universally — no exceptions for the
  standard library or any other package.
  - ✅ `import requests` then use `requests.RequestException`
  - ✅ `import pathlib` then use `pathlib.Path`
  - ✅ `import typing` then use `typing.Any`
  - ❌ `from requests import RequestException`
  - ❌ `from pathlib import Path`
  - ❌ `from typing import Any`

## Type Hints
- Type-hint all function arguments and return values without exception.
- Use built-in generic types where available (`list[str]`, `dict[str, int]`) rather than
  `typing.List`, `typing.Dict`, etc.

## Comments
- Do not add comments that merely explain what the code does — prefer self-documenting
  code through explicit, descriptive variable, function, and class names instead.
- Only add a comment when:
  1. The code is doing something that is not immediately obvious from reading it.
  2. The code is intentionally doing something non-standard, and the reason needs to be
     recorded (e.g. working around a bug, satisfying an unusual constraint).
