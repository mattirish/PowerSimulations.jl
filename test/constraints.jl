ps_model = PSI.CanonicalModel(Model(),
                              Dict{String, JuMP.Containers.DenseAxisArray{JuMP.VariableRef}}(),
                              Dict{String, JuMP.Containers.DenseAxisArray}(),
                              nothing,
                              Dict{String, PSI.JumpAffineExpressionArray}("var_active" => PSI.JumpAffineExpressionArray(undef, 14, 24),
                                                                         "var_reactive" => PSI.JumpAffineExpressionArray(undef, 14, 24)),
                              Dict{String,Any}(),
                              Dict());

@test  try
    @info "testing Active Power Only Range Constraints Thermal"
    PSI.activepower_variables(ps_model, generators5, 1:24)
    PSI.activepower_constraints(ps_model, generators5, PSI.ThermalDispatch, PM.DCPlosslessForm, 1:24)
    PSI.reactivepower_variables(ps_model, generators5, 1:24)
    PSI.reactivepower_constraints(ps_model, generators5, PSI.ThermalDispatch, PM.StandardACPForm, 1:24)
true finally end

@test  try
    @info "testing Active Power Rate of Change Constraints Thermal"
    PSI.activepower_variables(ps_model, generators5_uc, 1:24)
    PSI.activepower_constraints(ps_model, generators5_uc, PSI.ThermalDispatch, PM.DCPlosslessForm, 1:24)
    PSI.ramp_constraints(ps_model, generators5_uc, PSI.ThermalDispatch, PM.DCPlosslessForm, 1:24, zeros(4))
true finally end

@test  try
    @info "testing Full AC Model with Commitment Thermal"
    PSI.activepower_variables(ps_model, generators5_uc, 1:24)
    PSI.commitment_variables(ps_model, generators5_uc, 1:24);
    PSI.activepower_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment , PM.StandardACPForm, 1:24)
    PSI.ramp_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment, PM.StandardACPForm, 1:24, zeros(4))
    PSI.time_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment, PM.StandardACPForm, 1:24, zeros(4,2))
    PSI.reactivepower_variables(ps_model, generators5_uc, 1:24)
    PSI.reactivepower_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment , PM.StandardACPForm, 1:24)
true finally end

@test  try
    @info "testing Active Power Rate of Change Constraints Thermal Commitment"
    PSI.activepower_variables(ps_model, generators5_uc, 1:24)
    PSI.commitment_variables(ps_model, generators5_uc, 1:24);
    PSI.activepower_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment , PM.DCPlosslessForm, 1:24)
    PSI.ramp_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment, PM.DCPlosslessForm, 1:24, zeros(4))
true finally end

@test  try
    @info "testing Active Power Full Unit Commitment"
    PSI.activepower_variables(ps_model, generators5_uc, 1:24)
    PSI.commitment_variables(ps_model, generators5_uc, 1:24);
    PSI.activepower_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment , PM.DCPlosslessForm, 1:24)
    PSI.ramp_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment, PM.DCPlosslessForm, 1:24, zeros(4))
    PSI.time_constraints(ps_model, generators5_uc, PSI.ThermalUnitCommitment, PM.StandardACPForm, 1:24, zeros(4,2))
true finally end


@test  try
    PSI.activepower_variables(ps_model, generators_hg, 1:24)
    PSI.activepower_constraints(ps_model, generators_hg, PSI.HydroDispatchRunOfRiver, PM.DCPlosslessForm, 1:24)
    PSI.activepower_constraints(ps_model, generators_hg, PSI.HydroDispatchRunOfRiver, PM.StandardACPForm, 1:24)
    PSI.reactivepower_variables(ps_model, generators_hg, 1:24)
    PSI.reactivepower_constraints(ps_model, generators_hg, PSI.HydroDispatchRunOfRiver, PM.StandardACPForm, 1:24)
true finally end

@test  try
    PSI.activepower_variables(ps_model, generators_hg, 1:24)
    PSI.commitment_variables(ps_model, generators_hg, 1:24);
    PSI.activepower_constraints(ps_model, generators_hg, PSI.HydroCommitmentRunOfRiver, PM.DCPlosslessForm, 1:24)
    PSI.activepower_constraints(ps_model, generators_hg, PSI.HydroCommitmentRunOfRiver, PM.StandardACPForm, 1:24)
    PSI.reactivepower_variables(ps_model, generators_hg, 1:24)
    PSI.reactivepower_constraints(ps_model, generators_hg, PSI.HydroCommitmentRunOfRiver, PM.StandardACPForm, 1:24)
true finally end

@test  try
    PSI.activepower_variables(ps_model, renewables, 1:24)
    PSI.reactivepower_variables(ps_model, renewables, 1:24)
    PSI.activepower_constraints(ps_model, renewables, PSI.RenewableFullDispatch, PM.DCPlosslessForm, 1:24)
    PSI.reactivepower_constraints(ps_model, renewables, PSI.RenewableConstantPowerFactor, PM.StandardACPForm, 1:24)
    #TODO: Missing a test for full dispatch since there is no data for this case yet in the example files
true finally end


@test  try
    PSI.activepower_variables(ps_model, loads5_DA, 1:24)
    PSI.reactivepower_variables(ps_model, loads5_DA, 1:24)
    PSI.activepower_constraints(ps_model,  loads5_DA, PSI.InterruptiblePowerLoad,  PM.DCPlosslessForm, 1:24)
    PSI.activepower_constraints(ps_model,  loads5_DA, PSI.InterruptiblePowerLoad,  PM.StandardACPForm, 1:24)
    PSI.reactivepower_constraints(ps_model,  loads5_DA, PSI.InterruptiblePowerLoad, PM.StandardACPForm, 1:24)
    #TODO: Missing a test for full dispatch since there is no data for this case yet in the example files
true finally end