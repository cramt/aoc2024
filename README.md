# aoc2024

Advent of Code 2024 in VHDL, simulated with GHDL (VHDL-2008). Nothing here targets real hardware.

Each day lives in `dayXX/`. A day is either behavioral (a textio testbench, `just run`) or clocked (a stream entity tested from Julia with [JHDL](https://github.com/A-H-Technology/JHDL), `just test`).

```sh
nix develop
just new 02              # behavioral: scaffold day02/day02.vhd
just run 02              # analyze and simulate against input/02.txt
just run 02 other.txt    # same, against a different input
just wave 02             # open the waveform in Surfer

just new-stream 02       # clocked: scaffold day02/day02_stream.vhd and day02/test.jl
just test 02             # run day02/test.jl against input/02.example.txt
just stream 02           # stream input/02.txt through and print the answers
just stream 02 input/02.txt 1000000   # allow more cycles after the last byte
just wave-stream 02      # open the waveform of the last clocked run
```

## Clocked days

`tb/stream.jl` generates a testbench with JHDL that holds `RST` high for 5 cycles, then feeds the input one byte per clock:

| Port | Dir | Meaning |
| --- | --- | --- |
| `CLK`, `RST` | in | Driven by the testbench, synchronous reset |
| `DIN` | in | `std_logic_vector(7 downto 0)`, the current input byte |
| `DIN_VALID` | in | `DIN` holds a byte this cycle |
| `DIN_LAST` | in | High with the final byte |
| `PART1`, `PART2` | out | `unsigned(63 downto 0)` answers |
| `DONE` | out | Answers are read on the first cycle this is high |

JHDL can't stop the simulation on `DONE`, so every cycle of the budget (100k by default) is simulated and logged.

All `.vhd` files in the day's directory are compiled, so sub-entities can go in their own files and get their own JHDL tests in `test.jl`.

To try a local JHDL checkout: `nix develop --override-input jhdl path:../JHDL`.

## Inputs

Put each day's puzzle input in `input/<day>.txt` and the puzzle's example in `input/<day>.example.txt` yourself. Inputs are gitignored, per the AoC author's request not to redistribute them.
