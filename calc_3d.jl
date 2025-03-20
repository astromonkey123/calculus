include("calc_1d.jl")

const dy = 1e-3
const dz = 1e-3
const dt = 1e-3

f(x, y, z) = x + y + z
F(x, y, z) = [x, y, z]

function partial_x(f, x, y, z)
    """ Evaluate the partial derivative of f with respect to x at (x, y, z) 
    Parameters: f:R³ -> R, (x, y, z) ∈ R³
    """
    return (f(x + dx, y, z) - f(x, y, z)) / dx
end

function partial_y(f, x, y, z)
    """ Evaluate the partial derivative of f with respect to y at (x, y, z) 
    Parameters: f:R³ -> R, (x, y, z) ∈ R³
    """
    return (f(x, y + dy, z) - f(x, y, z)) / dy
end

function partial_z(f, x, y, z)
    """ Evaluate the partial derivative of f with respect to z at (x, y, z) 
    Parameters: f:R³ -> R, (x, y, z) ∈ R³
    """
    return (f(x, y, z + dz) - f(x, y, z)) / dz
end

function line_integral(f, x, y, z, a, b)
    """ Evaluate the line integral of a scalar function f along the curve (x(t), y(t), z(t)) from t = a to t = b 
    Parameters: f:R³ -> R, x:R -> R, y:R -> R, z:R -> R, a,b ∈ R
    """
    ys = [f(x(t), y(t), z(t)) * hypot(derivative(x, t), derivative(y, t), derivative(z, t)) for t in a:dt:b]
    return sum(ys * dt)
end

function path_integral(F, x, y, z)
    """ Evaluate the line integral of a vector function F along the curve (x(t), y(t), z(t)) from t = a to t = b 
    Parameters: F:R³ -> R³, x:R -> R, y:R -> R, z:R -> R, a,b ∈ R
    """
    ys = [F(x(t), y(t), z(t))[1] * derivative(x, t) + F(x(t), y(t), z(t))[2] * derivative(y, t) + F(x(t), y(t), z(t))[3] * derivative(z, t) for t in a:dt:b]
    return sum(ys * dt)
end

function gradient(f, x, y, z)
    """ Evaluate the gradient of f at (x, y, z) 
    Parameters: f:R³ -> R, (x, y, z) ∈ R³
    """
    return [partial_x(f, x, y, z), partial_y(f, x, y, z), partial_z(f, x, y, z)]
end

function divergence(F, x, y, z)
    """ Evaluate the derivative of F at (x, y, z) 
    Parameters: F:R³ -> R³, (x, y, z) ∈ R³
    """
    return partial_x(F, x, y, z)[1] + partial_y(F, x, y, z)[2] + partial_z(F, x, y, z)[3]
end

function curl(F, x, y, z)
    """ Evaluate the curl of F at (x, y, z) 
    Parameters: F:R³ -> R³, (x, y, z) ∈ R³
    """
    i = partial_z(F, x, y, z)[2] - partial_y(F, x, y, z)[3]
    j = partial_z(F, x, y, z)[1] - partial_x(F, x, y, z)[3]
    k = partial_y(F, x, y, z)[1] - partial_x(F, x, y, z)[2]
    return [i, -j, k]
end