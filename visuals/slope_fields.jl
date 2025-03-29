using GLMakie

include("utils.jl")

x_bounds = [-10, 10]
y_bounds = [-10, 10]
density = 30

xs = collect(LinRange(x_bounds..., density))
ys = collect(LinRange(y_bounds..., density))

fig = Figure(size=(700, 700))
ax = Axis(fig[1, 1], limits=(x_bounds..., y_bounds...))
set_theme!(merge(theme_black(), theme_latexfonts()))

f(x, y) = 0.5 * y * (2 - y)

function slope_field()
    us_norm = [1/hypot(1, f(x, y)) for x in xs, y in ys]
    vs_norm = [f(x, y)/hypot(1, f(x, y)) for x in xs, y in ys]

    colors = [RGBf(0.5 - 0.5l, 0.5, 0.5) for l in vs_norm]

    arrows!(ax, xs, ys, us_norm, vs_norm, color=vec(colors), arrowsize=0, lengthscale=0.5)

    on(events(fig).mousebutton) do event
        if event.action == Mouse.press
            x_pts = [map_value(events(ax).mouseposition[][1], 50, 684, x_bounds...)]
            y_pts = [map_value(events(ax).mouseposition[][2], 37, 682, y_bounds...)]
            euler_method(f, 0.01, 10, x_pts, y_pts)
            lines!(ax, x_pts, y_pts, color=:white)
        end
    end

    display(fig)
end

slope_field()