using GLMakie

function f(x)
    return atan(x)
end

function diff(f, x)
    dx = 1e-10
    return (f(x + dx) - f(x)) / dx
end

fig = Figure()
ax = Axis(fig[1, 1])

xs = collect(LinRange(-2, 2, 1000))
ys = [f(x) for x in xs]

function newton_method(f, x, iterations)
    for _ in 1:iterations
        y = f(x)
        m = diff(f, x)

        scatter!(ax, x, y, color=:blue)
        lines!(ax, [x, x - y/m], [y, 0], color=:green)

        x = x - (y / m)

        lines!(ax, [x, x], [f(x), 0], color=:green)
        display(fig)
        sleep(0.1)
    end

    return x
end

empty!(ax)

lines!(ax, xs, ys, color=:black)

newton_method(f, 1.4, 10)