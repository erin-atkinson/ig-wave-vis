abstract type AbstractPacket{F} end

struct GaussianPacket{F} <: AbstractPacket{F}
    x :: F
    z :: F
    k :: F
    m :: F
    σ :: F
end

function streamfunction(packet::GaussianPacket, x, z)
    x₀, z₀ = packet.x, packet.z
    r² = (x - x₀)^2 + (z - z₀)^2
    
    return exp(-r² / 2packet.σ^2) * cos(packet.k * x + packet.m * z) / sqrt(2π) / packet.σ
end


struct ModePacket{F} <: AbstractPacket{F}
    modes :: Modes{F}
    mode_amplitudes :: Array{Complex{F}, 2}
end

# Decompose a packet into modes
function ModePacket(packet::GaussianPacket{F}, modes::Modes{F}) where F
    xs = range(-modes.L/2, modes.L/2, modes.Nx)
    zs = range(bottom(modes.profile), top(modes.profile), modes.Nz)

    ψ = [streamfunction(packet, x, z) for x in xs, z in zs]
    mode_amplitudes = mode_transform(modes, ψ)
    return ModePacket{F}(modes, mode_amplitudes)
end

function streamfunction(packet::ModePacket{F}, t) where F
    modes = packet.modes
    return real.(inv_mode_transform(modes, packet.mode_amplitudes .* exp.(-1im .* modes.ωs .* t)))
end

function dominant_frequency(packet::ModePacket)
    return packet.modes.ωs[argmax(abs.(packet.mode_amplitudes))]
end