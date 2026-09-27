# aoc2024

Advent of Code 2024 in VHDL, simulated with GHDL (VHDL-2008). Nothing here targets real hardware.

```sh
nix develop
just new 02              # scaffold src/day02.vhd from the template
just run 02              # analyze and simulate against input/02.txt
just run 02 other.txt    # same, against a different input (e.g. the puzzle's example)
just wave 02             # open the waveform in Surfer
```

Put each day's puzzle input in `input/<day>.txt` yourself.

Inputs are gitignored, per the AoC author's request not to redistribute them.
