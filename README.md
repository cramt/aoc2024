# aoc2024

Advent of Code 2024 in VHDL, simulated with GHDL (VHDL-2008). Nothing here targets real hardware.

```sh
nix develop
export AOC_SESSION=...   # session cookie from adventofcode.com
just new 02              # scaffold src/day02.vhd from the template
just run 02              # fetch input if missing, analyze, elaborate, simulate
just wave 02             # open the waveform in Surfer
```

Inputs are gitignored, per the AoC author's request not to redistribute them.
