const Δ = 1e-3

function derivative(f, x)
    """ Evaluate the rate of change of a function f at x 
    Parameters: f:R -> R, x ∈ R
    """
    return (f(x + Δ) - f(x)) / Δ
end

function integral(f, a, b)
    """ Evaluate the definite integral of f from a to b 
    Parameters: f:R -> R, a,b ∈ R
    """
    ys = [f(x) for x in a:Δ:b]
    return sum(ys * Δ)
end