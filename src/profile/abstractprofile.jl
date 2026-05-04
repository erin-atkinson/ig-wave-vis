abstract type AbstractProfile{F} end

function domain(profile::AbstractProfile)
    return top(profile), bottom(profile)
end

function top(::AbstractProfile) end
function bottom(::AbstractProfile) end

# Buoyancy
function buoyancy(::AbstractProfile, z) end

# A profile needs to define the squared frequency and its derivative
function frequency_squared(::AbstractProfile, z) end
function frequency_squared_dz(::AbstractProfile, z) end

# The rest is general
function frequency(profile::AbstractProfile, z)
    return sqrt(frequency_squared(profile, z))
end

# Ray Hamiltonian
function Ω²(profile::AbstractProfile, _, z, k, m)
    return k^2 * frequency_squared(profile, z) / (k^2 + m^2)
end

# Since we have sufficient symmetry, we only use the positive root here
function Ω(profile::AbstractProfile, x, z, k, m)
    return sqrt(Ω²(profile, x, z, k, m))
end

# Ray tracing functions for positive root
function ∂Ω∂x(profile::AbstractProfile{F}, x, z, k, m) where F
    return zero(F)
end

function ∂Ω∂k(profile::AbstractProfile, _, z, k, m)
    return sign(k) * frequency(profile, z) * m^2 / sqrt(k^2 + m^2) / (k^2 + m^2)
end

function ∂Ω∂m(profile::AbstractProfile, _, z, k, m)
    return -m * abs(k) * frequency(profile, z) / sqrt(k^2 + m^2) / (k^2 + m^2)
end

function ∂Ω∂z(profile::AbstractProfile, _, z, k, m)
    return abs(k) * frequency_squared_dz(profile, z) / sqrt(k^2 + m^2) / frequency(profile, z)
end
