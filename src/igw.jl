using GLMakie
using Printf
using LinearAlgebra
using FFTW

function prettyrecord(observable, fig, filename, frames; record_kw...)
    N = length(frames)
    t0 = time()
    record(fig, filename, 1:N; record_kw...) do i
        observable[] = frames[i]
        
        t = time() - t0
        total_time = N * t / i
        
        str = @sprintf "%ds / %ds (%d / %d)" t total_time i N
        nl = i == N ? "\n" : "\r"
        
        print(str * nl)
    end
    return nothing
end

# Create the profiles
include("profile/profile.jl")
include("modes/modes.jl")
include("packet/packet.jl")

filename = ARGS[1]
profile_n = parse(Int64, ARGS[2])

θ = parse(Float64, ARGS[3])
λ = parse(Float64, ARGS[4])

# Final time or image
T_hr = parse(Float64, ARGS[5])
T = T_hr * 3600

Nx = 256
Nz = 256

# Geometry
H = 1000.0
L = 1000.0
N² = 1e-4
Δb = N² * H / 100

# Nodes for plotting profiles
profile_xs = range(-L/2, L/2, Nx)
profile_zs = range(-H, 0, Nz)

profile_names = [
    "Linear",
    "Quadratic",
    "Step",
]

profile_descriptions = [
    "Simple constant stratification profile",
    "Increasing stratification with depth",
    "Step change in buoyancy"
]

profiles = [
    LinearProfile(H, N²),
    QuadraticProfile(H, N², 3N²),
    PycnoclineProfile(0.2H, H, N², 9N², N², 0.1H)
]

profile_name = profile_names[profile_n]
profile = profiles[profile_n]

println("Creating modes for $profile_name...")
modes = Modes(profile, Nx, Nz, L)

extensions = [".mp4", ".png"]
image_extensions = [".png"]

valid_extension = any(map(e->endswith(filename, e), extensions))
valid_extension || @error "Please use a valid extension: $extensions"

image_only = any(map(e->endswith(filename, e), image_extensions))

T_str = @sprintf "%.1f" T_hr
λ_str = @sprintf "%.0f" λ
θ_str = @sprintf "%.2f" θ

if image_only 
    println("Creating an image of an internal wave packet with θ=$θ_str, λ=$λ_str m at $T_str hr in a $profile_name background buoyancy profile.")
else
    println("Creating a video of an internal wave packet with θ=$θ_str, λ=$λ_str m evolving for $T_str hr in a $profile_name background buoyancy profile.")
end

k = 2π / λ * sin(θ)
m = 2π / λ * cos(θ)
z = -500.0
δ = 50.0
N = 1200
ts = range(0, T, N)

n = Observable(1)
t = @lift ts[$n]

title = @lift let
    t_val = $t / 3600
    hr_str = @sprintf "%.1f" t_val
    L"\text{%$profile_name}, \quad t = %$hr_str \, \text{hr}, \quad \lambda=%$λ_str\,\text{m}, \quad \theta=%$θ_str"
end

println("Calculating modal decomposition")
gaussianpacket = GaussianPacket(0.0, z, k, m, δ)
modepacket = ModePacket(gaussianpacket, modes)
ω = Ω(profile, 0.0, z, k, m)

println("Plotting")
fig = Figure(; size=(600, 600))

xs = range(-L/2, L/2, Nx)
zs = range(bottom(profile), top(profile), Nz)
ψs = @lift streamfunction(modepacket, $t)

limits = (-L/2, L/2, -H, 0)

ax = Axis(fig[1, 1];
    xlabel = L"x / \text{m}",
    ylabel = L"z / \text{m}",
    title,
    aspect = DataAspect(),
    limits,
    xticks = -1000:250:1000,
    yticks = [-1000, -750, -500, -250, 0]
)

colorrange = (-maximum(abs, ψs[]), maximum(abs, ψs[]))
heatmap!(ax, xs, zs, ψs; colormap=:balance, colorrange)
heatmap!(ax, xs .+ L, zs, ψs; colormap=:balance, colorrange)
heatmap!(ax, xs .- L, zs, ψs; colormap=:balance, colorrange)
contour!(ax, [-L, L], zs, (x, z)->buoyancy(profile, z); levels=30, color=:black)
contour!(ax, [-L, L], zs, (x, z)->frequency(profile, z); levels=[ω], color=:red)

if image_only
    t[] = T
    save(filename, fig; px_per_unit=2)
else
    println("Recording...")
    prettyrecord(n, fig, filename, 1:N; px_per_unit=2, framerate=12)
end

fig