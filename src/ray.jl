ray = Ray(profile[], x₀, z₀[], K₀[], θ₀[])
ray_xs = Observable(ray.x)
ray_zs = Observable(ray.z)

ray_ts = Observable(ray.t)
ray_ks = Observable(ray.k)
ray_ms = Observable(ray.m)

ray_θs = Observable(angle(ray))
ray_θgs = Observable(atan.(∂Ω∂k(ray), ∂Ω∂m(ray)))

ray_vxs = Observable(∂Ω∂k(ray))
ray_vzs = Observable(∂Ω∂m(ray))

on(trace_ray.clicks) do n
    ray = Ray(profile[], x₀, z₀[], K₀[], θ₀[])

    ray_xs[] = ray.x
    ray_zs[] = ray.z

    ray_ts[] = ray.t

    ray_ks[] = ray.k
    ray_ms[] = ray.m

    ray_vxs[] = ∂Ω∂k(ray)
    ray_vzs[] = ∂Ω∂m(ray)
    ray_θs[] = angle(ray)
    ray_θgs[] = atan.(∂Ω∂k(ray), ∂Ω∂m(ray))
end

scatter!(ax_window, x₀, z₀; color=:green)
lines!(ax_window, ray_xs, ray_zs; color=:green)

cgx = @lift ∂Ω∂k($profile, x₀, $z₀, $k₀, $m₀)
cgz = @lift ∂Ω∂m($profile, x₀, $z₀, $k₀, $m₀)

phase_xs = @lift [x₀, x₀ + 40 * $k₀ / $K₀]
phase_zs = @lift [$z₀, $z₀ + 40 * $m₀ / $K₀]

group_xs = @lift [x₀, x₀ + 40 * $cgx / sqrt($cgx^2 + $cgz^2)]
group_zs = @lift [$z₀, $z₀ + 40 * $cgz / sqrt($cgx^2 + $cgz^2)]

lines!(ax_window, phase_xs, phase_zs; color=:blue)
lines!(ax_window, group_xs, group_zs; color=:green)

# Also do critical layers
critical_levels = @lift [Ω($profile, x₀, $z₀, $k₀, $m₀)]
contour!(ax_window, [-L/2, L/2], profile_zs, profile_Ns_3d; color=:magenta, levels=critical_levels)
