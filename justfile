std := "--std=08"
work := "--workdir=build"

default:
    @just --list

# --elab-run, not -e then -r: with mcode, a separate `ghdl -e` elaborates for
# real (opening the default INPUT_PATH) and ignores -g, breaking input overrides.

# Simulate a day's testbench against its input, e.g. `just run 01`
run day input=("input/" + day + ".txt"):
    @mkdir -p build
    ghdl -a {{std}} {{work}} src/day{{day}}.vhd
    ghdl --elab-run {{std}} {{work}} day{{day}}_tb -gINPUT_PATH={{input}} --wave=build/day{{day}}.ghw

# Open the waveform from the last run
wave day:
    surfer build/day{{day}}.ghw

# Copy the day template into a new day
new day:
    sed 's/dayXX/day{{day}}/g; s/XX\.txt/{{day}}.txt/' src/template.vhd > src/day{{day}}.vhd
