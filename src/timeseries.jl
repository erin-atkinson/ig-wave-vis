ts_hr = @lift $ray_ts ./ 3600

pos_limits = @lift (0, $ts_hr[end], -H, L/2)
cgs_limits = @lift begin
    y_min = min(minimum($ray_vxs), minimum($ray_vzs))
    y_max = max(maximum($ray_vxs), maximum($ray_vzs))
    Δy = y_max - y_min
    (0, $ts_hr[end], y_min - 0.1Δy, y_max + 0.1Δy)
end

angle_limits = @lift (0, $ts_hr[end], -π, π)

ax_pos = Axis(timeseries_gl[1, 1];
    xlabel = L"t / \text{hr}",
    ylabel = L"\{x, z\} / \text{m}",
    limits = pos_limits,
)
hidexdecorations!(ax_pos; ticks=false)

ax_cgs = Axis(timeseries_gl[2, 1];
    xlabel = L"t / \text{hr}",
    ylabel = L"\{v_x, v_z\} / \text{m}\,\text{s}^{-1}",
    limits = cgs_limits, 
)
hidexdecorations!(ax_cgs; ticks=false)

ax_angle = Axis(timeseries_gl[3, 1];
    xlabel = L"t / \text{hr}",
    ylabel = L"\{θ, θ_g\}",
    limits = angle_limits,
    yticks = ([-π, -π/2, 0, π/2, π], ["-π", "-π/2", "0", "π/2", "π"])
)

lines!(ax_pos, ts_hr, ray_xs)
lines!(ax_pos, ts_hr, ray_zs)

lines!(ax_cgs, ts_hr, ray_vxs)
lines!(ax_cgs, ts_hr, ray_vzs)

lines!(ax_angle, ts_hr, ray_θs)
lines!(ax_angle, ts_hr, ray_θgs)
