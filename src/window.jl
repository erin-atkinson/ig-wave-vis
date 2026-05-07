ax_window = Axis(fig[1:4, 1:4];
    xlabel = L"x / \text{m}",
    ylabel = L"z / \text{m}",
    limits = (-L / 2, L / 2, -H, 0),
    aspect = DataAspect()
)

profile_bs_3d = @lift [buoyancy($profile, z) for x in 1:2, z in profile_zs]
profile_Ns_3d = @lift [frequency($profile, z) for x in 1:2, z in profile_zs]

ctr = contour!(ax_window, [-L/2, L/2], profile_zs, profile_bs_3d; 
    color = :black,
    levels = 40, 
)
