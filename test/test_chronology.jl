stages = Dict(1 => Stage(template_uc, 24, Hour(24), 1, c_sys5_uc, GLPK_optimizer,  Dict(0 => Sequential())),
              2 => Stage(template_ed, 12, Minute(5), 24, c_sys5_ed, GLPK_optimizer, Dict(1 => Synchronize(24,1), 0 => Sequential()), TimeStatusChange(:ON_ThermalStandard)))

if !isdir(joinpath(pwd(), "testing_reading_results"))
    file_path = mkdir(joinpath(pwd(), "testing_reading_results"))
else
    file_path = (joinpath(pwd(), "testing_reading_results"))
end
sim = Simulation("test", 2, stages, file_path; verbose = true)
sim_results = execute!(sim)
stage = ["stage-1", "stage-2"]

@testset "Testing to verify length of time_stamp" begin
    for ix in stage
        results = load_simulation_results(ix, sim_results)
        @test size(unique(results.time_stamp), 1) == size(results.time_stamp, 1)
    end
end

@testset "Testing to verify no gaps in the time_stamp" begin
    for (ix, s) in enumerate(sim.stages)
        results = load_simulation_results(stage[ix], sim_results)
        resolution = convert(Dates.Minute, get_sim_resolution(s))
        time_stamp = results.time_stamp
        length = size(time_stamp,1)
        test = results.time_stamp[1,1]:resolution:results.time_stamp[length,1]
        @test time_stamp[!,:Range] == test
    end
end

rm(file_path, recursive = true)