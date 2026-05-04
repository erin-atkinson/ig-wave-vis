# Create the profiles
include("profile/profile.jl")

# Geometry
H = 1000.0
L = 1000.0
N² = 1e-4
Δb = N² * H / 100

profile_names = [
    "Linear",
    "Step",
]

profile_descriptions = [
    "Simple constant stratification profile",
    "Step change in buoyancy"
]

profiles = [
    LinearProfile(H, f),
    PycnoclineProfile(0.2H, H, N², 10N², N², 0.03H)
]