abstract type AbstractProfile end

function domain(profile::AbstractProfile)
    return profile.top, profile.bottom
end

top(profile::AbstractProfile) = profile.top
bottom(profile::AbstractProfile) = profile.bottom

function buoyancy_frequency(::AbstractProfile, z) end

abstract type FunctionProfile <: AbstractProfile end

struct LinearProfile{F where F <: Number} <: FunctionProfile
    top :: F
    bottom :: F
    N² :: F
end

LinearProfile() = LinearProfile(0.0, -1.0, 1.0)

function (profile::LinearProfile)(z)
    return (z - profile.top) * profile.N²
end

function buoyancy_frequency(profile::LinearProfile, _)
    return profile.N²
end

struct PycnoclineProfile{F where F <: Number} <: FunctionProfile
    top :: F
    bottom :: F

    N²_ml :: F
    N²_pycnocline :: F
    N²_deep :: F

    δ :: F
end

function PycnoclineProfile(top, bottom, δ, N²_pycnocline)
    N²_ml = 0.01
    N²_deep = 1.0
    return PycnoclineProfile(
        top,
        bottom,
        N²_ml,
        N²_pycnocline,
        N²_deep,
        δ
    )
end

function (profile::PycnoclineProfile)(z)
    a = profile.N²_ml * log(1 + exp(z))
    b = -profile.N²_deep * log(1 + exp(-z))
    c = N²_pycnocline * profile.δ * tanh(z / profile.δ)
    return a + b + c
end

function buoyancy_frequency(profile::PycnoclineProfile, z)
    a = profile.N²_ml * exp(z) / (1 + exp(z))
    b = profile.N²_deep * exp(-z) / log(1 + exp(-z))
    c = N²_pycnocline * sech(z / profile.δ)^2
    return a + b + c
end