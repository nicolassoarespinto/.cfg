from __future__ import annotations

import argparse
import csv
import fnmatch
import re
import sys
from pathlib import Path
from typing import List, Sequence

from rich.console import Console
from rich.table import Table


def _format_value(value: str, decimals: int) -> str:
  """Format a cell value, rounding numeric values to specified decimal places."""
  try:
    num = float(value)
    # If it's effectively an integer, display as integer
    if num == int(num):
      return str(int(num))
    # Otherwise format with specified decimals
    return f"{num:.{decimals}f}"
  except (ValueError, TypeError):
    # Not a number, return as-is
    return value


def _build_arg_parser() -> argparse.ArgumentParser:
  parser = argparse.ArgumentParser(
    description="Quickly preview CSV data with optional regex filtering."
  )
  parser.add_argument("file", type=Path, help="Path to the CSV file.")
  parser.add_argument(
    "-g",
    "--glob",
    action="append",
    dest="globs",
    help="Glob pattern to filter columns. Use multiple times. Prefix with ! to exclude (e.g., -g 'PI_*' -g '!*ADM').",
  )
  parser.add_argument(
    "--rgx",
    help="Deprecated: use -g/--glob instead. Regex to filter column names.",
  )
  parser.add_argument(
    "--tail",
    action="store_true",
    help="Show the last N rows instead of the first N (default: head).",
  )
  parser.add_argument(
    "-n",
    "--lines",
    type=int,
    default=10,
    help="Number of data rows to display (default: 10).",
  )
  parser.add_argument(
    "-d",
    "--decimals",
    "--round",
    type=int,
    default=3,
    help="Round numeric values to N decimal places (default: 3).",
  )
  return parser


def _load_rows(csv_path: Path) -> List[List[str]]:
  with csv_path.open(newline="") as handle:
    return list(csv.reader(handle))


def _match_column(col_name: str, includes: List[str], excludes: List[str]) -> bool:
  """Check if a column name matches include patterns and doesn't match exclude patterns."""
  # If no includes specified, include everything by default
  if not includes:
    included = True
  else:
    # Column must match at least one include pattern
    included = any(fnmatch.fnmatch(col_name, pattern) for pattern in includes)

  # Column must not match any exclude pattern
  excluded = any(fnmatch.fnmatch(col_name, pattern) for pattern in excludes)

  return included and not excluded


def _filter_columns_glob(
  header: Sequence[str],
  rows: Sequence[Sequence[str]],
  globs: List[str] | None
) -> tuple[List[str], List[List[str]]]:
  """Filter columns using glob patterns. Patterns starting with ! are exclusions."""
  if not globs:
    return list(header), [list(r) for r in rows]

  # Separate include and exclude patterns
  includes = [g for g in globs if not g.startswith("!")]
  excludes = [g[1:] for g in globs if g.startswith("!")]

  # Find indices of columns that match
  matching_indices = [
    i for i, col_name in enumerate(header)
    if _match_column(col_name, includes, excludes)
  ]

  if not matching_indices:
    return [], []

  # Filter header and rows to only include matching columns
  filtered_header = [header[i] for i in matching_indices]
  filtered_rows = [[row[i] for i in matching_indices] for row in rows]

  return filtered_header, filtered_rows


def _filter_columns_regex(
  header: Sequence[str],
  rows: Sequence[Sequence[str]],
  pattern: re.Pattern[str] | None
) -> tuple[List[str], List[List[str]]]:
  """Filter columns by matching header names against a regex pattern (deprecated)."""
  if pattern is None:
    return list(header), [list(r) for r in rows]

  # Find indices of columns that match the pattern
  matching_indices = [i for i, col_name in enumerate(header) if pattern.search(col_name)]

  if not matching_indices:
    return [], []

  # Filter header and rows to only include matching columns
  filtered_header = [header[i] for i in matching_indices]
  filtered_rows = [[row[i] for i in matching_indices] for row in rows]

  return filtered_header, filtered_rows


def _select_rows(rows: Sequence[Sequence[str]], tail: bool, lines: int) -> List[List[str]]:
  if lines <= 0:
    return []
  if not rows:
    return []
  return list(rows[-lines:] if tail else rows[:lines])


def _render_table(header: Sequence[str], rows: Sequence[Sequence[str]], decimals: int = 3) -> None:
  console = Console(width=300)
  table = Table()
  for col in header:
    table.add_column(col)
  for row in rows:
    formatted_row = [_format_value(cell, decimals) for cell in row]
    table.add_row(*formatted_row)
  console.print(table)


def main(argv: Sequence[str] | None = None) -> int:
  parser = _build_arg_parser()
  args = parser.parse_args(argv)

  if args.lines <= 0:
    print("n/--lines must be positive.", file=sys.stderr)
    return 1

  csv_path: Path = args.file
  if not csv_path.exists():
    print(f"CSV file not found: {csv_path}", file=sys.stderr)
    return 1

  try:
    rows = _load_rows(csv_path)
  except Exception as exc:  # noqa: BLE001
    print(f"Failed to read CSV: {exc}", file=sys.stderr)
    return 1

  if not rows:
    print("CSV file is empty.", file=sys.stderr)
    return 1

  header, data_rows = rows[0], rows[1:]

  # Filter columns - prioritize globs over deprecated regex
  if args.globs:
    filtered_header, filtered_rows = _filter_columns_glob(header, data_rows, args.globs)
  elif args.rgx:
    pattern = re.compile(args.rgx)
    filtered_header, filtered_rows = _filter_columns_regex(header, data_rows, pattern)
  else:
    filtered_header, filtered_rows = list(header), [list(r) for r in data_rows]

  if not filtered_header:
    print("No columns match the filter patterns.", file=sys.stderr)
    return 1

  # Select rows (head or tail)
  selected = _select_rows(filtered_rows, args.tail, args.lines)

  if not selected:
    print("No rows to display.", file=sys.stderr)
    return 1

  _render_table(filtered_header, selected, args.decimals)
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
