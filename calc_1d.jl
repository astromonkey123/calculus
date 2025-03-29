import LinearAlgebra

const Δ = 1e-3

function derivative(f, x)
    """ Evaluate the rate of change of a function f at x 
    Parameters: f:R -> R, x ∈ R
    Returns: df/dx
    """
    try
        return (f(x + Δ) - f(x)) / Δ
    catch
        try
            (f(x) - f(x - Δ)) / Δ
        catch
            error("f is not defined on [x - Δ, x + Δ]")
        end
    end
end

function integral(f, a, b)
    """ Evaluate the definite integral of f from a to b 
    Parameters: f:R -> R, a,b ∈ R
    Returns: ∫ f dx
    """
    ys = [f(x) for x in a:Δ:b]
    return sum(ys * Δ)
end