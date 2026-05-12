
struct QuadraticProfile{F} <: AbstractProfile{F}
    H :: F

    N²_top :: F
    N²_bottom :: F
end

top(::QuadraticProfile{F}) where F = zero(F)
bottom(profile::QuadraticProfile) = -profile.H

function buoyancy(profile::QuadraticProfile, z)
    return z * profile.N²_top + (profile.N²_top - profile.N²_bottom) * z^2 / 2profile.H
end

function frequency_squared(profile::QuadraticProfile, z)
    return profile.N²_top + (profile.N²_top - profile.N²_bottom) * z / profile.H
end

function frequency_squared_dz(profile::QuadraticProfile, z)
    return (profile.N²_top - profile.N²_bottom) / profile.H
end
