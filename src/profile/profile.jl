abstract type AbstractProfile end

function domain(profile::AbstractProfile)
    profile.top, profile.bottom
end

function buoyancy_frequency(::AbstractProfile) end

