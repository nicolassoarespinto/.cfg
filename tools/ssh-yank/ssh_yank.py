#!/usr/bin/env python3
# /// script
# requires-python = ">=3.8"
# dependencies = []
# ///
import sys
import base64
import os


def main():
    if len(sys.argv) != 2:
        print("usage: ssh-yank <file>")
        sys.exit(1)

    path = sys.argv[1]

    with open(path, "rb") as f:
        data = f.read()

    b64 = base64.b64encode(data).decode("ascii")

    # OSC 52 sequence
    osc52 = f"\033]52;c;{b64}\007"

    # Wrap for tmux if needed
    if os.environ.get("TMUX"):
        # Tmux requires DCS pass-through wrapping
        seq = f"\033Ptmux;\033{osc52}\033\\"
    else:
        seq = osc52

    # Write directly to stdout
    sys.stdout.write(seq)
    sys.stdout.flush()


if __name__ == "__main__":
    main()

