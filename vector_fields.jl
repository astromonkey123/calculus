using GLMakie

x_bounds = [-10, 10]
y_bounds = [-10, 10]
z_bounds = [-10, 10]
density = 20

xs = collect(LinRange(x_bounds..., density))
ys = collect(LinRange(y_bounds..., density))
zs = collect(LinRange(z_bounds..., density))

f(x, y) = 0.5 * y * (2 - y)
F(x, y) = [x, y]
F(x, y, z) = [y, -x, 1/z]


function map_value(value, domain_start, domain_end, range_start, range_end)
    normalized = (value - domain_start) / (domain_end - domain_start)
    mapped = (normalized * (range_end - range_start)) + range_start
    return mapped
end


function slope_field()
    fig = Figure(size=(700, 700))
    ax = Axis(fig[1, 1], limits=(x_bounds..., y_bounds...))
    set_theme!(merge(theme_black(), theme_latexfonts()))

    us = [1/hypot(f(x, y)...) for x in xs, y in ys]
    vs = [f(x, y)/hypot(f(x, y)...) for x in xs, y in ys]

    colors = [RGBf(0.75-0.25l, 0.75, 0.75) for l in vs]

    arrows!(ax, xs, ys, us, vs, color=vec(colors), arrowsize=0, lengthscale=0.25)

    x_pts = []
    y_pts = []

    on(events(fig).mousebutton) do event
        if event.action == Mouse.press
            x_pts = []
            y_pts = []
            # println(events(ax).mouseposition)
            mapped_x = map_value(events(ax).mouseposition[][1], 51, 685, x_bounds...)
            mapped_y = map_value(events(ax).mouseposition[][2], 36, 683, y_bounds...)
            mpos = [mapped_x, mapped_y]
            append!(x_pts, mpos[1])
            append!(y_pts, mpos[2])
            for t in 0:0.01:10
                x_next = x_pts[end] + 0.05
                y_next = y_pts[end] + f(x_pts[end], y_pts[end]) * 0.05
                append!(x_pts, x_next)
                append!(y_pts, y_next)
            end
            lines!(ax, x_pts, y_pts, color=:white)
        end
    end

    return fig
end


function vector_field_2d()
    fig = Figure(size=(700, 700))
    ax = Axis(fig[1, 1], limits=(x_bounds..., y_bounds...))
    set_theme!(merge(theme_black(), theme_latexfonts()))

    us = [F(x, y)[1] for x in xs, y in ys]
    vs = [F(x, y)[2] for x in xs, y in ys]
    us_norm = [F(x, y)[1]/hypot(F(x, y)...) for x in xs, y in ys]
    vs_norm = [F(x, y)[2]/hypot(F(x, y)...) for x in xs, y in ys]

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
                x_next = x_pts[end] + F(x_pts[end], y_pts[end])[1] * 0.05
                y_next = y_pts[end] + F(x_pts[end], y_pts[end])[2] * 0.05
                append!(x_pts, x_next)
                append!(y_pts, y_next)
            end
            lines!(ax, x_pts, y_pts, color=:white)
        end
    end

    fig
end

function vector_field_3d()
    fig = Figure(size=(700, 700))
    ax = Axis3(fig[1, 1], limits=(x_bounds..., y_bounds..., z_bounds...))
    set_theme!(merge(theme_black(), theme_latexfonts()))

    us = [F(x, y, z)[1] for x in xs, y in ys, z in zs]
    vs = [F(x, y, z)[2] for x in xs, y in ys, z in zs]
    ws = [F(x, y, z)[3] for x in xs, y in ys, z in zs]

    points = [Point3f(x, y, z) for x in xs, y in ys, z in zs]

    vecs_norm = [Vec3f(F(x, y, z)/hypot(F(x, y, z)...)) for x in xs, y in ys, z in zs]

    lengths = [hypot(us[i], vs[i], ws[i])/hypot(maximum(us), maximum(vs), maximum(ws)) for i in eachindex(us)]
    colors = [RGBf(l, 0.5, 0.5) for l in lengths]

    arrows!(ax, vec(points), vec(vecs_norm), color=colors, arrowsize=0.025, lengthscale=0.1)

    x_pts = [0.0]
    y_pts = [5.0]
    z_pts = [5.0]
    Δt = 0.01
    for t in 0:Δt:100
        x_next = x_pts[end] + F(x_pts[end], y_pts[end], z_pts[end])[1] * Δt
        y_next = y_pts[end] + F(x_pts[end], y_pts[end], z_pts[end])[2] * Δt
        z_next = z_pts[end] + F(x_pts[end], y_pts[end], z_pts[end])[3] * Δt
        append!(x_pts, x_next)
        append!(y_pts, y_next)
        append!(z_pts, z_next)
    end
    lines!(ax, x_pts, y_pts, z_pts, color=:white)

    fig
end

vector_field_3d()