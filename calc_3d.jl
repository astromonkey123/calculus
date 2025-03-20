include("calc_1d.jl")

const dy = 1e-3
const dz = 1e-3
const dt = 1e-3

f(x, y, z) = x + y + z
F(x, y, z) = [x, y, z]

function partial_x(f, x, y, z)
    return (f(x + dx, y, z) - f(x, y, z)) / dx
end

function partial_y(f, x, y, z)
    return (f(x, y + dy, z) - f(x, y, z)) / dy
end

function partial_z(f, x, y, z)
    return (f(x, y, z + dz) - f(x, y, z)) / dz
end

function line_integral(f, x, y, z, a, b)
    ys = [f(x(t), y(t), z(t)) * hypot(derivative(x, t), derivative(y, t), derivative(z, t)) for t in a:dt:b]
    return sum(ys * dt)
end

function path_integral(F, x, y, z)
    ys = [F(x(t), y(t), z(t))[1] * derivative(x, t) + F(x(t), y(t), z(t))[2] * derivative(y, t) + F(x(t), y(t), z(t))[3] * derivative(z, t) for t in a:dt:b]
    return sum(ys * dt)
end

function gradient(f, x, y, z)
    return [partial_x(f, x, y, z), partial_y(f, x, y, z), partial_z(f, x, y, z)]
end

function divergence(F, x, y, z)
    return partial_x(F, x, y, z)[1] + partial_y(F, x, y, z)[2] + partial_z(F, x, y, z)[3]
end

function curl(F, x, y, z)
    i = partial_z(F, x, y, z)[2] - partial_y(F, x, y, z)[3]
    j = partial_z(F, x, y, z)[1] - partial_x(F, x, y, z)[3]
    k = partial_y(F, x, y, z)[1] - partial_x(F, x, y, z)[2]
    return [i, -j, k]
end