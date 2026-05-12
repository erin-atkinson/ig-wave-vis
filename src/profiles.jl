# Profile selection
Label(profile_gl[1, 1], "Select profile: ")

profile_menu = Menu(profile_gl[1, 2];
    options = zip(profile_names, 1:length(profile_names)),
)

profile = Observable{AbstractProfile}(profiles[1])
profile_description = Observable(profile_descriptions[1])

Label(profile_gl[2, 1:2], profile_description; word_wrap=true)

ax_profile_b = Axis(profile_gl[1:2, 3], limits=(nothing, nothing, -H, 0))
hidexdecorations!(ax_profile_b)
hideydecorations!(ax_profile_b)

ax_profile_N = Axis(profile_gl[1:2, 4], limits=(nothing, nothing, -H, 0))
hidexdecorations!(ax_profile_N)
hideydecorations!(ax_profile_N)

on(profile_menu.selection) do s
    profile[] = profiles[s]
    profile_description[] = profile_descriptions[s]
    xlims!(ax_profile_b, (nothing, nothing))
    xlims!(ax_profile_N, (nothing, nothing))
end
notify(profile_menu.selection)

profile_bs = @lift [buoyancy($profile, z) for z in profile_zs]
profile_Ns = @lift [frequency($profile, z) for z in profile_zs]

lines!(ax_profile_b, profile_bs, profile_zs)
lines!(ax_profile_N, profile_Ns, profile_zs)
