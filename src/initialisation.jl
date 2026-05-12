# Create the profiles
include("profile/profile.jl")
include("ray/ray.jl")

# Geometry
H = 1000.0
L = 1000.0
N² = 1e-4
Δb = N² * H / 100

# Nodes for plotting profiles
profile_xs = range(-L/2, L/2, 128)
profile_zs = range(-H, 0, 128)

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
