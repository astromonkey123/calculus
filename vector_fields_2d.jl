using GLMakie


x_bounds = [-10, 10]
y_bounds = [-10, 10]
density = 35

xs = collect(LinRange(x_bounds..., density))
ys = collect(LinRange(y_bounds..., density))

function map_value(value, domain_start, domain_end, range_start, range_end)
    normalized = (value - domain_start) / (domain_end - domain_start)
    mapped = (normalized * (range_end - range_start)) + range_start
    return mapped
end

function f(x, y)
    return [x, y]
end

fig = Figure(size=(700, 700))
ax = Axis(fig[1, 1], limits=(x_bounds..., y_bounds...), ylabel="theta dot", xlabel="theta")
set_theme!(merge(theme_black(), theme_latexfonts()))

us = [f(x, y)[1] for x in xs, y in ys]
vs = [f(x, y)[2] for x in xs, y in ys]
us_norm = [f(x, y)[1]/hypot(f(x, y)...) for x in xs, y in ys]
vs_norm = [f(x, y)[2]/hypot(f(x, y)...) for x in xs, y in ys]

lengths = [hypot(us[i], vs[i])/hypot(maximum(us), maximum(vs)) for i in eachindex(vs)]
colors = [RGBf(l, 0.5, 0.5) for l in lengths]

arrows!(ax, xs, ys, us_norm, vs_norm, color=vec(colors), arrowsize=5, lengthscale=0.5)

x_pts = []
y_pts = []

on(events(fig).mousebutton) do event
    if event.action == Mouse.press
        x_pts = []
        y_pts = []
        # println(events(ax).mouseposition)
        mapped_x = map_value(events(ax).mouseposition[][1], 69, 684, x_bounds...)
        mapped_y = map_value(events(ax).mouseposition[][2], 52, 681, y_bounds...)
        mpos = [mapped_x, mapped_y]
        append!(x_pts, mpos[1])
        append!(y_pts, mpos[2])
        for t in 0:0.01:10
            x_next = x_pts[end] + f(x_pts[end], y_pts[end])[1] * 0.05
            y_next = y_pts[end] + f(x_pts[end], y_pts[end])[2] * 0.05
            append!(x_pts, x_next)
            append!(y_pts, y_next)
        end
        lines!(ax, x_pts, y_pts, color=:white)
    end
end

fig