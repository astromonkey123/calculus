include("calc_1d.jl")

function partial_x(f, x, y)
    """ Evaluate the partial derivative of f with respect to x at (x, y) 
    Parameters: f:R² -> R, (x, y) ∈ R²
    """
    return (f(x + Δ, y) - f(x, y)) / Δ
end

function partial_y(f, x, y)
    """ Evaluate the partial derivative of f with respect to y at (x, y) 
    Parameters: f:R² -> R, (x, y) ∈ R²
    """
    return (f(x, y + Δ) - f(x, y)) / Δ
end

function line_integral(f, x, y, a, b)
    """ Evaluate the line integral of a scalar function f along the curve (x(t), y(t)) from t = a to t = b 
    Parameters: f:R² -> R, x:R -> R, y:R -> R, a,b ∈ R
    """
    h(t) = f(x(t), y(t)) * hypot(derivative(x, t), derivative(y, t))
    return integral(h, a, b)
end

function path_integral(F, x, y)
    """ Evaluate the line integral of a vector function F along the curve (x(t), y(t)) from t = a to t = b 
    Parameters: F:R² -> R², x:R -> R, y:R -> R, a,b ∈ R
    """
    h(t) = F(x(t), y(t))[1] * derivative(x, t) + F(x(t), y(t))[2] * derivative(y, t)
    return integral(h, a, b)
end

function gradient(f, x, y)
    """ Evaluate the gradient of f at (x, y) 
    Parameters: f:R² -> R, (x, y) ∈ R²
    """
    return [partial_x(f, x, y), partial_y(f, x, y)]
end

function divergence(F, x, y)
    """ Evaluate the divergence of F at (x, y) 
    Parameters: F:R² -> R², (x, y) ∈ R²
    """
    return partial_x(F, x, y)[1] + partial_y(F, x, y)[2]
end