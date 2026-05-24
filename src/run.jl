# Run initialisation
using GLMakie
using Printf
using DifferentialEquations

include("initialisation.jl")

# Create figure layout
fig = Figure(;
    fontsize = 18,
    size = (1200, 1000)
)

# Internal layouts
profile_gl = GridLayout(fig[5:6, 1:4])
timeseries_gl = GridLayout(fig[1:2, 5:7])
#packet_gl = GridLayout(fig[3:4, 5:6])
slider_gl = GridLayout(fig[3:4, 5:7])
#info_gl = GridLayout(fig[5, 5:7])
button_gl = GridLayout(fig[5:6, 5:7])

# Setup sliders and buttons
include("sliders.jl")
include("buttons.jl")

# Setup profile selection
include("profiles.jl")

# Setup window
include("window.jl")

# Setup ray
include("ray.jl")

# Setup timeseries plots
include("timeseries.jl")

fig
