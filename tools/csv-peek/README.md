# csv-peek

Quick CSV inspection tool that displays data in a readable table format using the rich library.

## Usage

```sh
# Install locally as an editable uv tool
uv tool install --editable ./tools/csv-peek

# Preview the first 10 rows (default: 3 decimal places)
csv-peek path/to/file.csv

# Filter columns with glob patterns
csv-peek path/to/file.csv -g 'PI_*'
csv-peek path/to/file.csv -g 'F_*' -g 'PI_*'

# Exclude columns with ! prefix
csv-peek path/to/file.csv -g 'PI_*' -g '!*ADM'

# Combine includes and excludes
csv-peek path/to/file.csv -g '*' -g '!*STAR*' -g '!Q*'

# Control decimal places
csv-peek path/to/file.csv -d 2
csv-peek path/to/file.csv --round 2

# Combine filters, tail, and rounding
csv-peek path/to/file.csv -g 'SELIC*' --tail -n 5 -d 4
```

## Options

- `-g, --glob`: glob pattern to filter columns (use multiple times). Prefix with `!` to exclude.
- `--rgx`: *(deprecated)* regex to filter columns - use `-g` instead.
- `--tail`: show the last `n` rows instead of the first `n`.
- `-n, --lines`: number of data rows to display (default: 10).
- `-d, --decimals, --round`: round numeric values to N decimal places (default: 3).

## Glob Pattern Examples

- `PI_*` - matches columns starting with "PI_"
- `*_USD` - matches columns ending with "_USD"
- `Q?` - matches Q1, Q2, Q3, Q4
- `!*ADM` - excludes columns ending with "ADM"
- `!*STAR*` - excludes columns containing "STAR"
