main_paths = ["./src", "./PowerSimulationsPlots"]
for main_path in main_paths
    format(
        main_path;
        whitespace_ops_in_indices = true,
        remove_extra_newlines = true,
        verbose = true,
    )
end
