# Create sliders
slider_λ = Slider(slider_gl[2, 1:4]; range=10:10:100, startvalue=20)
slider_θ = Slider(slider_gl[4, 1:4]; range=range(-π, π, 101), startvalue=1.0)
slider_z = Slider(slider_gl[6, 1:4]; range=range(-H, 0, 101), startvalue=-H/2)

# Slider labels
Label(slider_gl[1, 1], L"\lambda_0 =")
Label(slider_gl[3, 1], L"\theta_0 =")
Label(slider_gl[5, 1], L"z_0 =")

# Wave packet initial conditions
x₀ = 0.0
λ₀ = slider_λ.value
θ₀ = slider_θ.value
Δθ₀ = 0.1
z₀ = slider_z.value

K₀ = @lift 2π / $λ₀
k₀ = @lift $K₀ * sin($θ₀)
m₀ = @lift $K₀ * cos($θ₀)

# Slider values
slider_λ_label = @lift let λ = $λ₀,
    str = @sprintf "%.0f" λ
    L"%$str \, \text{m}"
end

slider_θ_label = @lift let θ = $θ₀,
    str = @sprintf "%.2f" θ
    L"%$str"
end

slider_z_label = @lift let z = $z₀,
    str = @sprintf "%.0f" z
    L"%$str \, \text{m}"
end

Label(slider_gl[1, 2:4], slider_λ_label)
Label(slider_gl[3, 2:4], slider_θ_label)
Label(slider_gl[5, 2:4], slider_z_label)
