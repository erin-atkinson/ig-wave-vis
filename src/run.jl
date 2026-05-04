# Run initialisation
include("initialisation.jl")

# Create figure layout
fig = Figure(;
    fontsize = 18,
)

# Internal layouts
profile_gl = GridLayout(fig[5:6, 1:4])
timeseries_gl = GridLayout(fig[1:2, 5:7])
packet_gl = GridLayout(fig[3:4, 5:6])
slider_gl = GridLayout(fig[3:4, 6:7])
info_gl = GridLayout(fig[5, 5:7])
button_gl = GridLayout(fig[6, 5:7])

# Setup sliders
include("sliders.jl")

# Setup profile selection
include("profiles.jl")
fig
