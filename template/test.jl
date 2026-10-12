using Test
include(joinpath(@__DIR__, "..", "tb", "stream.jl"))

const DAY = "XX"

# Put the puzzle's example in input/XX.example.txt and its answers here.
# A `nothing` answer is reported as skipped rather than failed.
const EXAMPLE = (part1=nothing, part2=nothing)

@testset "day$DAY" begin
    @testset "example" begin
        r = stream_day(DAY, "input/$DAY.example.txt")
        for part in (:part1, :part2)
            want = EXAMPLE[part]
            if isnothing(want)
                @test_skip r[part] == want
            else
                @test r[part] == want
            end
        end
    end

    # Sub-entities can get their own cycle-by-cycle tests with JHDL's
    # DUT/Testbench/Simulation + verify, see the JHDL README.
end
