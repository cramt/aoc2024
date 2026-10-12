using Test, Random
include(joinpath(@__DIR__, "..", "tb", "stream.jl"))

const DAY = "00"

# day00 has no puzzle text, so inputs are random and Julia computes the expected answers
function random_input(path, n; seed, trailing_newline=true)
    nums = rand(Xoshiro(seed), 0:1_000_000, n)
    mkpath(dirname(path))
    write(path, join(nums, "\n") * (trailing_newline ? "\n" : ""))
    return nums
end

@testset "day$DAY" begin
    # Unit test of the sub-entity alone, checked cycle by cycle
    @testset "add10" begin
        u32 = VHDL.Unsigned(VHDL.Range(31, 0))
        sl = VHDL.std_logic()
        dut = DUT(
            name="add10",
            generics=Generic[],
            ports=[
                Port("X", u32, 0, In),
                Port("X_VALID", sl, 0, In),
                Port("Y", u32, nothing, Out),
                Port("Y_VALID", sl, nothing, Out),
            ],
        )
        tb = Testbench(name="add10_tb", generics=Generic[], constants=Constant[], signals=Port[], dut=dut)
        build = "build/day00_add10"
        construct_testbench(tb; directory=build)

        # Includes the top of the range to check the 32-bit wraparound
        xs = [rand(Xoshiro(1), 0:Int(typemax(UInt32)), 200); typemax(UInt32) - 9; typemax(UInt32)]
        sim = Simulation(
            testbench=tb,
            sources=["day00/add10.vhd", joinpath(build, "add10_tb.vhd")],
            build_directory=build,
            generics=Generic[],
            stims=[PortStim("X", u32, xs, In), PortStim("X_VALID", sl, fill(1, length(xs)), In)],
        )
        @test verify(sim, [
                PortStim("Y", u32, (xs .+ 10) .% 2^32, Out),
                PortStim("Y_VALID", sl, fill('1', length(xs)), Out),
            ]; latency=1)
    end

    @testset "stream: $name" for (name, path, n, trailing_newline) in [
        # input/00.txt doubles as the day's input for `just stream 00`
        ("1000 numbers", "input/00.txt", 1000, true),
        ("no trailing newline", "build/day00_inputs/no_newline.txt", 5, false),
        ("single number", "build/day00_inputs/single.txt", 1, true),
    ]
        nums = random_input(path, n; seed=n, trailing_newline)
        r = stream_day(DAY, path)
        @test r.part1 == sum(nums .+ 10)
        @test r.part2 == n
    end
end
