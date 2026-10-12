# Feeds a puzzle input to a clocked dayXX_stream entity one byte per cycle via
# a JHDL-generated testbench and returns PART1/PART2 from the first cycle DONE is high.
#
# As a library (from a day's test.jl): include it and call stream_day.
# As a script: julia tb/stream.jl <day> <input> <cycles>

using JHDL

const CLK_PERIOD_NS = 20

# `cycles` bounds how long the DUT may take to raise DONE after the last byte.
function stream_day(day::AbstractString, input_path::AbstractString; cycles::Integer=100_000)
    name = "day$(day)_stream"
    build = joinpath("build", name)

    byte = VHDL.std_logic_vector(VHDL.Range(7, 0))
    bit = VHDL.std_logic()
    answer = VHDL.Unsigned(VHDL.Range(63, 0))

    dut = DUT(
        name=name,
        generics=Generic[],
        ports=[
            Port("DIN", byte, 0, In),
            Port("DIN_VALID", bit, 0, In),
            Port("DIN_LAST", bit, 0, In),
            Port("PART1", answer, nothing, Out),
            Port("PART2", answer, nothing, Out),
            Port("DONE", bit, nothing, Out),
        ],
    )

    tb = Testbench(
        name="$(name)_tb",
        generics=Generic[],
        constants=Constant[],
        signals=Port[],
        dut=dut,
        clk_period_ns=Constant("CLK_PERIOD", VHDL.Time(), CLK_PERIOD_NS),
        drain_cycles=Constant("DRAIN_CYCLES", VHDL.Integer(), cycles),
        finish_on="DONE",
    )
    construct_testbench(tb; directory=build)

    bytes = read(input_path)
    isempty(bytes) && error("$input_path is empty")
    n = length(bytes)

    # Every .vhd in the day's directory, so sub-entities can live in their own files
    day_dir = "day$(day)"
    sources = [joinpath(day_dir, f) for f in readdir(day_dir) if endswith(f, ".vhd")]

    sim = Simulation(
        testbench=tb,
        sources=[sources; joinpath(build, "$(name)_tb.vhd")],
        build_directory=build,
        generics=Generic[],
        stims=[
            PortStim("DIN", byte, Int.(bytes), In),
            PortStim("DIN_VALID", bit, fill(1, n), In),
            PortStim("DIN_LAST", bit, [zeros(Int, n - 1); 1], In),
        ],
        # 5 reset cycles + stim rows + drain, plus slack so DRAIN_CYCLES is the timeout, not the stop time
        stop_time_ms=cld((5 + n + cycles) * CLK_PERIOD_NS, 1_000_000) + 1,
    )

    out = Dict(p.name => p.value for p in simulate(sim))

    done_at = findfirst(==('1'), out["DONE"])
    isnothing(done_at) && error(
        "DONE never went high within $cycles cycles after $input_path ended. " *
        "Raise `cycles` or check the waveform (`just wave-stream $day`).")

    # Cycle numbers count rising edges after reset, so they match the waveform's edge count
    return (part1=out["PART1"][done_at], part2=out["PART2"][done_at], done_at=done_at, after_last=done_at - n)
end

if abspath(PROGRAM_FILE) == @__FILE__
    length(ARGS) == 3 || error("usage: julia tb/stream.jl <day> <input> <cycles>")
    day, input_path, cycles = ARGS
    r = stream_day(day, input_path; cycles=parse(Int, cycles))
    println("DONE at cycle $(r.done_at) ($(r.after_last) after the last byte)")
    # missing means PART1/PART2 held a metavalue (U, X, ...) when DONE rose
    println("part1: ", r.part1)
    println("part2: ", r.part2)
end
