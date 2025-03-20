const dx = 1e-3

f(x) = x

function derivative(f, x)
    return (f(x + dx) - f(x)) / dx
end

function integral(f, a, b)
    ys = [f(x) for x in a:dx:b]
    return sum(ys * dx)
end