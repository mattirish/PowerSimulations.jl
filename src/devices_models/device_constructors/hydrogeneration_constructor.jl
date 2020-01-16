############### Any Hydro using HydroDispatch with AC ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{H, D},
                           ::Type{S};
                           kwargs...) where {H<:PSY.HydroGen,
                                             D<:AbstractHydroDispatchFormulation,
                                             S<:PM.AbstractPowerModel}
    devices = PSY.get_components(H, sys)

    if validate_available_devices(devices, H)
        return
    end

    #Variables
    activepower_variables!(psi_container, devices);
    reactivepower_variables!(psi_container, devices);

    #Constraints
    activepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    reactivepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    feed_forward!(psi_container, H, model.feed_forward)

    #Cost Function
    cost_function(psi_container, devices, D, S)

    return
end

############### Any Hydro using Hydro SeasonalFlow with AC ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{H, HydroDispatchSeasonalFlow},
                           ::Type{S};
                           kwargs...) where {H<:PSY.HydroGen,
                                             S<:PM.AbstractPowerModel}
    devices = PSY.get_components(H, sys)

    if validate_available_devices(devices, H)
        return
    end

    #Variables
    activepower_variables!(psi_container, devices);
    reactivepower_variables!(psi_container, devices);

    #Constraints
    activepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    reactivepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    budget_constraints!(psi_container, devices, model, S, model.feed_forward)
    feed_forward!(psi_container, H, model.feed_forward)

    #Cost Function
    cost_function(psi_container, devices, HydroDispatchSeasonalFlow, S)

    return
end

############### Any Hydro using Hydro UC with AC ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{H, D},
                           ::Type{S};
                           kwargs...) where {H<:PSY.HydroGen,
                                             D<:AbstractHydroUnitCommitment,
                                             S<:PM.AbstractPowerModel}
    devices = PSY.get_components(H, sys)

    if validate_available_devices(devices, H)
        return
    end

    #Variables
    activepower_variables!(psi_container, devices);
    reactivepower_variables!(psi_container, devices);

    #Initial Conditions
    initial_conditions!(psi_container, devices, model.formulation)

    #Constraints
    activepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    reactivepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    commitment_constraints!(psi_container, devices, model, S, model.feed_forward)
    feed_forward!(psi_container, H, model.feed_forward)

    #Cost Function
    cost_function(psi_container, devices, D, S)

    return
end

############### Any Hydro using HydroDispatch ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{H, D},
                           ::Type{S};
                           kwargs...) where {H<:PSY.HydroGen,
                                             D<:AbstractHydroDispatchFormulation,
                                             S<:PM.AbstractActivePowerModel}
    devices = PSY.get_components(H, sys)

    if validate_available_devices(devices, H)
        return
    end

    #Variables
    activepower_variables!(psi_container, devices);

    #Constraints
    activepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    feed_forward!(psi_container, H, model.feed_forward)

    #Cost Function
    cost_function(psi_container, devices, D, S)

    return
end

############### Any Hydro using Hydro Seasonal Flow ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{H, HydroDispatchSeasonalFlow},
                           ::Type{S};
                           kwargs...) where {H<:PSY.HydroGen,
                                             S<:PM.AbstractActivePowerModel}
    devices = PSY.get_components(H, sys)

    if validate_available_devices(devices, H)
        return
    end

    #Variables
    activepower_variables!(psi_container, devices);

    #Constraints
    activepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    budget_constraints!(psi_container, devices, model, S, model.feed_forward)
    feed_forward!(psi_container, H, model.feed_forward)

    #Cost Function
    cost_function(psi_container, devices, HydroDispatchSeasonalFlow, S)

    return
end

############### Any Hydro using Hydro UC ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{H, D},
                           ::Type{S};
                           kwargs...) where {H<:PSY.HydroGen,
                                             D<:AbstractHydroUnitCommitment,
                                             S<:PM.AbstractActivePowerModel}

    devices = PSY.get_components(H, sys)

    if validate_available_devices(devices, H)
        return
    end

    #Variables
    activepower_variables!(psi_container, devices);
    commitment_variables!(psi_container, devices)

    #Initial Conditions
    initial_conditions!(psi_container, devices, model.formulation)

    #Constraints
    activepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    commitment_constraints!(psi_container, devices, model, S, model.feed_forward)
    feed_forward!(psi_container, H, model.feed_forward)

    #Cost Function
    cost_function(psi_container, devices, D, S)

    return
end

###############  Any Hydro using HydroFixed ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{H, HydroFixed},
                           ::Type{S};
                           kwargs...) where {H<:PSY.HydroGen,
                                             S<:PM.AbstractPowerModel}
    devices = PSY.get_components(H, sys)

    if validate_available_devices(devices, H)
        return
    end

    nodal_expression!(psi_container, devices, S)

    return
end

################## HydroFix using AbsHydroFormulation - reverts to HydroFixed ###############
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{PSY.HydroFix, D},
                           ::Type{S};
                           kwargs...) where {D<:AbstractHydroFormulation,
                                             S<:PM.AbstractPowerModel}
    @warn("The Formulation $(D) only applies to Dispatchable Hydro, *
               Consider Changing the Device Formulation to HydroFixed")

    construct_device!(psi_container,
                      DeviceModel(PSY.HydroFix, HydroFixed),
                      S;
                      kwargs...)
end

############### HydroFix using ROR ################
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{PSY.HydroFix, D},
                           ::Type{S};
                           kwargs...) where {D<:AbstractHydroDispatchFormulation,
                                             S<:PM.AbstractActivePowerModel}
    devices = PSY.get_components(PSY.HydroFix, sys)

    if validate_available_devices(devices, PSY.HydroFix)
        return
    end

    #Variables
    activepower_variables!(psi_container, devices);

    #Constraints
    activepower_constraints!(psi_container, devices, model, S, model.feed_forward)
    feed_forward!(psi_container, PSY.HydroFix, model.feed_forward)

    #Cost Function
    #cost_function(psi_container, devices, D, S)

    return
end

########### HydroFix using HydroFixed ###############
function construct_device!(psi_container::PSIContainer, sys::PSY.System,
                           model::DeviceModel{PSY.HydroFix, HydroFixed},
                           ::Type{S};
                           kwargs...) where {S<:PM.AbstractPowerModel}
    devices = PSY.get_components(PSY.HydroFix, sys)

    if validate_available_devices(devices, PSY.HydroFix)
        return
    end

    nodal_expression!(psi_container, devices, S)

    return
end
