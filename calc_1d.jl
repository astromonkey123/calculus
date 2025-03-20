const dx = 1e-3

f(x) = x

function derivative(f, x)
    """ Evaluate the rate of change of a function f at x 
    Parameters: f:R -> R, x ∈ R
    """
    return (f(x + dx) - f(x)) / dx
end

function integral(f, a, b)
    """ Evaluate the definite integral of f from a to b 
    Parameters: f:R -> R, a,b ∈ R
    """
    ys = [f(x) for x in a:dx:b]
    return sum(ys * dx)
end