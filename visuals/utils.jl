function map_value(value, domain_start, domain_end, range_start, range_end)
    """ Map a number from one range to another """
    normalized = (value - domain_start) / (domain_end - domain_start)
    mapped = (normalized * (range_end - range_start)) + range_start
    return mapped
end

function euler_method(f, Δt, duration, x_pts, y_pts)
    for _ in 0:Δt:duration
        x_next = x_pts[end] + Δt
        y_next = y_pts[end] + f(x_pts[end], y_pts[end]) * Δt
        append!(x_pts, x_next)
        append!(y_pts, y_next)
    end
end

function euler_method_2d(F, Δt, duration, x_pts, y_pts)
    for _ in 0:Δt:duration
        x_next = x_pts[end] + F(x_pts[end], y_pts[end])[1] * 0.01
        y_next = y_pts[end] + F(x_pts[end], y_pts[end])[2] * 0.01
        append!(x_pts, x_next)
        append!(y_pts, y_next)
    end
end

function euler_method_3d(F, Δt, duration, x_pts, y_pts, z_pts)
    for _ in 0:Δt:duration
        x_next = x_pts[end] + F(x_pts[end], y_pts[end], z_pts[end])[1] * Δt
        y_next = y_pts[end] + F(x_pts[end], y_pts[end], z_pts[end])[2] * Δt
        z_next = z_pts[end] + F(x_pts[end], y_pts[end], z_pts[end])[3] * Δt
        append!(x_pts, x_next)
        append!(y_pts, y_next)
        append!(z_pts, z_next)
    end
end