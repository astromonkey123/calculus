include("calc_1d.jl")

const dy = 1e-3
const dt = 1e-3

f(x, y) = x + y
F(x, y) = [x, y]

function partial_x(f, x, y)
    return (f(x + dx, y) - f(x, y)) / dx
end

function partial_y(f, x, y)
    return (f(x, y + dy) - f(x, y)) / dy
end

function line_integral(f, x, y, a, b)
    ys = [f(x(t), y(t)) * hypot(derivative(x, t), derivative(y, t)) for t in a:dt:b]
    return sum(ys * dt)
end

function path_integral(F, x, y)
    ys = [F(x(t), y(t))[1] * derivative(x, t) + F(x(t), y(t))[2] * derivative(y, t) for t in a:dt:b]
    return sum(ys * dt)
end

function gradient(f, x, y)
    return [partial_x(f, x, y), partial_y(f, x, y)]
end

function divergence(F, x, y)
    return partial_x(F, x, y)[1] + partial_y(F, x, y)[2]
end