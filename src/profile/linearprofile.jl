"""
    LinearProfile
Linear buoyancy profile in domain (-H, 0)
    H: Depth
    N²: Stratification
"""
struct LinearProfile{F} <: AbstractProfile{F}
    H :: F
    N² :: F
end

top(::LinearProfile{F}) where F = zero(F)
bottom(profile::LinearProfile) = -profile.H


function buoyancy(profile::LinearProfile, z)
    return (z + profile.H) * profile.N²
end

frequency_squared(profile::LinearProfile, _) = profile.N²
frequency_squared_dz(::LinearProfile, _) = 0

LinearProfile() = LinearProfile(1.0, 1.0)
