include("../calc_1d.jl")

f(x) = x^2

function newton_method(f, x, iters)
    """ An algorithm to find zeros of a function f by repeatedly finding the x-intercepts of a tangent lines from an initial x value
    Parameters: f:R -> R, x ∈ R, iters ∈ Z
    """
    for _ in 1:iters
        y = f(x)
        m = derivative(f, x)
        x = x - (y / m)
    end
    return x
end