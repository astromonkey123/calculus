using GLMakie

include("utils.jl")
include("../calc_3d.jl")

x_bounds = [-10, 10]
y_bounds = [-10, 10]
z_bounds = [-10, 10]
density = 10

xs = collect(LinRange(x_bounds..., density))
ys = collect(LinRange(y_bounds..., density))
zs = collect(LinRange(z_bounds..., density))

fig = Figure(size=(700, 700))
set_theme!(merge(theme_black(), theme_latexfonts()))

function vector_field_2d(F, show_div, show_curl)
    ax = Axis(fig[1, 1], limits=(x_bounds..., y_bounds...))

    us = [F(x, y)[1] for x in xs, y in ys]
    vs = [F(x, y)[2] for x in xs, y in ys]
    us_norm = [F(x, y)[1]/hypot(F(x, y)...) for x in xs, y in ys]
    vs_norm = [F(x, y)[2]/hypot(F(x, y)...) for x in xs, y in ys]

    lengths = [hypot(us[i], vs[i])/hypot(maximum(us), maximum(vs)) for i in eachindex(vs)]
    colors = [RGBf(l, 0.5, 0.5) for l in lengths]

    heatmap_range = 5

    if show_div
        divF = [divergence(F, x, y) for x in xs, y in ys]
        heatmap!(ax, xs, ys, divF, colormap=:seaborn_icefire_gradient, interpolate=:true, colorrange=(-heatmap_range, heatmap_range), alpha=0.5)
    elseif show_curl
        curlF = [curl(F, x, y) for x in xs, y in ys]
        heatmap!(ax, xs, ys, curlF, colormap=:seaborn_icefire_gradient, interpolate=:true, colorrange=(-heatmap_range, heatmap_range), alpha=0.5)
    end

    arrows!(ax, xs, ys, us_norm, vs_norm, color=vec(colors), arrowsize=5, lengthscale=0.4)

    on(events(fig).mousebutton) do event
        if event.action == Mouse.press
            println(events(ax).mouseposition)
            x_pts = [map_value(events(ax).mouseposition[][1], 50, 684, x_bounds...)]
            y_pts = [map_value(events(ax).mouseposition[][2], 37, 682, y_bounds...)]
            euler_method_2d(F, 0.01, 10, x_pts, y_pts)
            lines!(ax, x_pts, y_pts, color=:white)
        end
    end

    display(fig)
end

function vector_field_3d(F, show_curl)
    ax = Axis3(fig[1, 1], limits=(x_bounds..., y_bounds..., z_bounds...))

    us = [F(x, y, z)[1] for x in xs, y in ys, z in zs]
    vs = [F(x, y, z)[2] for x in xs, y in ys, z in zs]
    ws = [F(x, y, z)[3] for x in xs, y in ys, z in zs]

    points = [Point3f(x, y, z) for x in xs, y in ys, z in zs]

    vecs_norm = [Vec3f(F(x, y, z)/hypot(F(x, y, z)...)) for x in xs, y in ys, z in zs]

    lengths = [hypot(us[i], vs[i], ws[i])/hypot(maximum(us), maximum(vs), maximum(ws)) for i in eachindex(us)]
    colors = [RGBf(l, 0.5, 0.5) for l in lengths]

    if show_curl
        curlF = [Vec3f(curl(F, x, y, z)) for x in xs, y in ys, z in zs]
        arrows!(ax, vec(points), vec(curlF), color=:green, arrowsize=0.02, lengthscale=0.025)
    end

    arrows!(ax, vec(points), vec(vecs_norm), color=colors, arrowsize=0.025, lengthscale=0.075)

    x_pts = [0.0]
    y_pts = [-2.0]
    z_pts = [1.0]
    euler_method_3d(F, 0.01, 100, x_pts, y_pts, z_pts)
    lines!(ax, x_pts, y_pts, z_pts, color=:white)

    display(fig)
end

vector_field_3d((x,y,z) -> [sin(y), sin(x), sin(x*y)], false)

""" 
Examples 

Varying divergence:
vector_field_2d((x,y) -> [sin(x), sin(y)], true, false)

Varying curl:
vector_field_2d((x,y) -> [sin(y), sin(x)], false, true)
"""