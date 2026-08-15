#!/usr/bin/env node
// Reads JSON on stdin, writes TOON on stdout. Used by bin/nvim-agent as the
// output-boundary encoder (internal logic stays plain JSON).
import { encode } from "@toon-format/toon";

const chunks = [];
for await (const chunk of process.stdin) chunks.push(chunk);
const input = JSON.parse(Buffer.concat(chunks).toString("utf8"));
process.stdout.write(encode(input) + "\n");
