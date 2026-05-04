abstract type AbstractRay end

struct Ray{F, P} <: AbstractRay
    profile :: P
    
    t :: AbstractVector{F}
    x :: AbstractVector{F}
    z :: AbstractVector{F}
    k :: AbstractVector{F}
    m :: AbstractVector{F}
end


"""
    Ray(profile, x₀, z₀, K₀, θ₀)

Create a ray with initial position (x₀, z₀), wavenumber magnitude K₀ and angle θ₀ in 
profile
"""
function Ray(profile::AbstractProfile, x₀::Number, z₀::Number, K₀::Number, θ₀::Number)
    k₀ = K₀ * sin(θ₀)
    m₀ = K₀ * cos(θ₀)
    u₀ = [x₀, z₀, k₀, m₀]
    
    tspan = (0, stop_time(profile, u₀))
    cb = stop_callback(profile, u₀)
    step_func!(du, u, p, t) = ray_step_func!(du, u, profile)

    prob = ODEProblem(step_func!, u₀, tspan)
    sol = solve(prob; callback=cb)

    x = [u[1] for u in sol.u]
    z = [u[2] for u in sol.u]
    k = [u[3] for u in sol.u]
    m = [u[4] for u in sol.u]
    
    return Ray(profile, sol.t, x, z, k, m)
end

# Time based on vertial phase velocity?
function stop_time(profile, u₀)
    return (top(profile) - bottom(profile)) / abs(∂Ω∂m(profile, u₀...))
end

# Stop if ray leaves domain
function stop_callback(profile, u₀)
    condition(u, _, _) = u[2] > top(profile) || u[1] < bottom(profile)
    return DiscreteCallback(condition, terminate!)
end

# Hamiltonian ray equations
function ray_step_func!(du, u, profile::AbstractProfile)
    du[1] = ∂Ω∂k(profile, u[1], u[2], u[3], u[4])
    du[2] = ∂Ω∂m(profile, u[1], u[2], u[3], u[4])
    du[3] = -∂Ω∂x(profile, u[1], u[2], u[3], u[4])
    du[4] = -∂Ω∂z(profile, u[1], u[2], u[3], u[4])

    return nothing
end
