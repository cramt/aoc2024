std := "--std=08"
work := "--workdir=build"

default:
    @just --list

# Simulate a day's testbench against its input, e.g. `just run 01`
run day input=("input/" + day + ".txt"): (fetch day)
    @mkdir -p build
    ghdl -a {{std}} {{work}} src/day{{day}}.vhd
    ghdl -e {{std}} {{work}} day{{day}}_tb
    ghdl -r {{std}} {{work}} day{{day}}_tb -gINPUT_PATH={{input}} --wave=build/day{{day}}.ghw

# Open the waveform from the last run
wave day:
    surfer build/day{{day}}.ghw

# Download a day's input; needs AOC_SESSION (the `session` cookie from adventofcode.com)
fetch day:
    #!/usr/bin/env bash
    set -euo pipefail
    out=input/{{day}}.txt
    [ -f "$out" ] && exit 0
    : "${AOC_SESSION:?set AOC_SESSION to your adventofcode.com session cookie}"
    mkdir -p input
    curl -sSf --cookie "session=$AOC_SESSION" \
      "https://adventofcode.com/2024/day/$((10#{{day}}))/input" -o "$out"

# Copy the day template into a new day
new day:
    sed 's/dayXX/day{{day}}/g; s/XX\.txt/{{day}}.txt/' src/template.vhd > src/day{{day}}.vhd
