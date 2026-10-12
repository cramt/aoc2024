std := "--std=08"
work := "--workdir=build"

default:
    @just --list

# --elab-run, not -e then -r: with mcode, a separate `ghdl -e` elaborates for
# real (opening the default INPUT_PATH) and ignores -g, breaking input overrides.

# Simulate a day's behavioral testbench against its input, e.g. `just run 01`
run day input=("input/" + day + ".txt"):
    @mkdir -p build
    ghdl -a {{std}} {{work}} day{{day}}/day{{day}}.vhd
    ghdl --elab-run {{std}} {{work}} day{{day}}_tb -gINPUT_PATH={{input}} --wave=build/day{{day}}.ghw

# Open the waveform from the last run
wave day:
    surfer build/day{{day}}.ghw

# Scaffold a behavioral day
new day:
    @mkdir -p day{{day}}
    sed 's/dayXX/day{{day}}/g; s/XX\.txt/{{day}}.txt/' template/dayXX.vhd > day{{day}}/day{{day}}.vhd

# Run a clocked day's JHDL tests (day<day>/test.jl)
test day: julia-deps
    julia --project=. day{{day}}/test.jl

# Stream an input into a clocked day and print the answers; `cycles` caps the run after the last byte
stream day input=("input/" + day + ".txt") cycles="100000": julia-deps
    julia --project=. tb/stream.jl {{day}} {{input}} {{cycles}}

# Open the waveform from the last clocked run
wave-stream day:
    surfer build/day{{day}}_stream/waveform.fst

# Scaffold a clocked day: the stream entity plus its JHDL tests
new-stream day:
    @mkdir -p day{{day}}
    sed 's/XX/{{day}}/g' template/dayXX_stream.vhd > day{{day}}/day{{day}}_stream.vhd
    sed 's/XX/{{day}}/g' template/test.jl > day{{day}}/test.jl

# Install the Julia deps pinned in Manifest.toml (a no-op once they're there)
julia-deps:
    @julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Move JHDL's pin in Manifest.toml to the tip of its main branch
julia-update:
    julia --project=. -e 'using Pkg; Pkg.update("JHDL")'
