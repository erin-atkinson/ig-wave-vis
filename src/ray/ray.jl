abstract type AbstractRay end

struct Ray{F, P} <: AbstractRay
    profile :: P

    x :: AbstractVector{F}
    z :: AbstractVector{F}
    k :: AbstractVector{F}
    m :: AbstractVector{F}
end


"""
    Ray(profile, x₀, z₀, K₀, θ₀)

Create a ray with initial position (x₀, z₀), wavenumber magnitude K₀ and angle θ₀ in 
"""
function Ray(profile::AbstractProfile, x₀, z₀, K₀, θ₀)

end