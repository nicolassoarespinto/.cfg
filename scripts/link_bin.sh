#!/usr/bin/env bash

# Script to create symlinks in ~/.local/bin for tools in dotfiles/bin/
# Only creates symlinks if there are no name conflicts

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Determine dotfiles directory (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
BIN_DIR="$DOTFILES_DIR/bin"
TARGET_DIR="$HOME/.local/bin"

echo "Linking tools from $BIN_DIR to $TARGET_DIR"
echo ""

# Create target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Creating $TARGET_DIR${NC}"
    mkdir -p "$TARGET_DIR"
fi

# Track statistics
linked_count=0
skipped_count=0
error_count=0

# Iterate through files in bin directory
if [ ! -d "$BIN_DIR" ]; then
    echo -e "${RED}Error: $BIN_DIR does not exist${NC}"
    exit 1
fi

for file in "$BIN_DIR"/*; do
    # Skip if no files found (glob doesn't match)
    [ -e "$file" ] || continue

    filename=$(basename "$file")
    target_path="$TARGET_DIR/$filename"

    # Check if target already exists
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        # Check if it's already a symlink pointing to our file
        if [ -L "$target_path" ] && [ "$(readlink -f "$target_path")" = "$(readlink -f "$file")" ]; then
            echo -e "${GREEN}✓${NC} $filename (already linked)"
            linked_count=$((linked_count + 1))
        else
            echo -e "${YELLOW}⊘${NC} $filename (conflict: target already exists)"
            skipped_count=$((skipped_count + 1))
        fi
    else
        # Create the symlink
        if ln -s "$file" "$target_path"; then
            echo -e "${GREEN}✓${NC} $filename (linked)"
            linked_count=$((linked_count + 1))
        else
            echo -e "${RED}✗${NC} $filename (failed to create symlink)"
            error_count=$((error_count + 1))
        fi
    fi
done

# Print summary
echo ""
echo "Summary:"
echo "  Linked: $linked_count"
if [ $skipped_count -gt 0 ]; then
    echo "  Skipped (conflicts): $skipped_count"
fi
if [ $error_count -gt 0 ]; then
    echo "  Errors: $error_count"
fi
