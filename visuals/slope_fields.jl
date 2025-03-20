using GLMakie

x_bounds = [-10, 10]
y_bounds = [-10, 10]
density = 20

xs = collect(LinRange(x_bounds..., density))
ys = collect(LinRange(y_bounds..., density))

f(x, y) = 0.5 * y * (2 - y)

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