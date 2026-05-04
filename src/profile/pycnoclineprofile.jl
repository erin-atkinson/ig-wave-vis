
struct PycnoclineProfile{F} <: AbstractProfile{F}
    h :: F
    H :: F

    N²_ml :: F
    N²_pycnocline :: F
    N²_deep :: F

    δ :: F
end

top(::PycnoclineProfile{F}) where F = zero(F)
bottom(profile::PycnoclineProfile) = -profile.H

function buoyancy(profile::PycnoclineProfile, z)
    x = (z + profile.h) / profile.δ
    a = profile.N²_ml * log(1 + exp(x)) * profile.δ
    b = -profile.N²_deep * log(1 + exp(-x)) * profile.δ
    c = profile.N²_pycnocline * profile.δ * tanh(x)

    return a + b + c
end

function frequency_squared(profile::PycnoclineProfile, z)
    x = (z + profile.h) / profile.δ
    a = profile.N²_ml * exp(x) / (1 + exp(x))
    b = profile.N²_deep * exp(-x) / (1 + exp(-x))
    c = profile.N²_pycnocline * sech(x)^2

    return a + b + c
end

function frequency_squared_dz(profile::PycnoclineProfile, z)
    x = (z + profile.h) / profile.δ
    a = profile.N²_ml * exp(x) / (1 + exp(x))^2 / profile.δ
    b = -profile.N²_deep * exp(-x) / (1 + exp(-x))^2 / profile.δ
    c = -2profile.N²_pycnocline * tanh(x) * sech(x)^2 / profile.δ
    
    return a + b + c
end

function PycnoclineProfile(h::F, H::F, δ::F, N²_pycnocline::F) where F
    N²_ml = 0.01
    N²_deep = 1.0
    return PycnoclineProfile{F}(
        h,
        H,
        N²_ml,
        N²_pycnocline,
        N²_deep,
        δ
    )
end
