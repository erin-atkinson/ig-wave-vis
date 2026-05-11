# Generate modal decomposition
struct Modes{F}
    profile :: AbstractProfile{F}
    Nx :: Integer
    Nz :: Integer
    L :: F
    
    ks :: Vector{F}
    ωs :: Array{F, 2}
    cs :: Array{F, 2}
    vectors :: Array{F, 3}
end

function A_term(profile, zs, k, i, j)
    #i == 1 && return 0.0
    #i == length(zs) && return 0.0

    N² = frequency_squared(profile, zs[j])
    Δz = zs[2] - zs[1]

    i == j+1 && return -2.0 / (N² * Δz^2)
    i == j-1 &&  return -2.0 / (N² * Δz^2)
    i == j && return (k^2 + 1.0) / N²
    return 0.0
end

function create_modes(profile, N, k)
    zs = range(bottom(profile), top(profile), N)
    A = [A_term(profile, zs, k, i, j) for i in 1:N, j in 1:N]
    return eigen(A)
end

function Modes(profile::AbstractProfile{F}, Nx, Nz, L) where F
    ks = fftfreq(Nx, Nx / L)[:]

    ωs = zeros(F, Nx, Nz)
    cs = zeros(F, Nx, Nz)
    vectors = zeros(F, Nx, Nz, Nz)

    for (i, k) in enumerate(ks)
        eig = create_modes(profile, Nz, k)
        # Keep only real frequencies?
        cs[i, :] .= map(eig.values) do value
            value > 0 ? 1 / sqrt(value) : 0.0
        end
        #cs[i, :] .= 1 ./ sqrt.(eig.values)
        ωs[i, :] .= k .* cs[i, :]
        vectors[i, :, :] .= eig.vectors
    end

    return Modes(profile, Nx, Nz, L, ks, ωs, cs, vectors)
end

function mode_transform(modes::Modes{F}, arr) where F
    ψ_xfft = fft(arr, 1)
    mode_amplitudes = zeros(complex(F), modes.Nx, modes.Nz)

    for i in 1:modes.Nx, n in 1:modes.Nz
        mode_amplitudes[i, n] = sum(ψ_xfft[i, :] .* modes.vectors[i, :, n])
    end

    return mode_amplitudes
end

function inv_mode_transform(modes::Modes{F}, arr) where F
    ψ_xfft = zeros(complex(F), modes.Nx, modes.Nz)

    for i in 1:modes.Nx, n in 1:modes.Nz
        ψ_xfft[i, :] .+= arr[i, n] * modes.vectors[i, :, n]
    end

    return ifft(ψ_xfft, 1)
end