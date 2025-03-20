using GLMakie


x_bounds = [-30, 30]
y_bounds = [-30, 30]
z_bounds = [-30, 30]
density = 10

xs = collect(LinRange(x_bounds..., density))
ys = collect(LinRange(y_bounds..., density))
zs = collect(LinRange(z_bounds..., density))

function map_value(value, domain_start, domain_end, range_start, range_end)
    normalized = (value - domain_start) / (domain_end - domain_start)
    mapped = (normalized * (range_end - range_start)) + range_start
    return mapped
end

function f(x, y, z)
    return [y, -x, 1/z]
end

fig = Figure(size=(700, 700))
ax = Axis3(fig[1, 1], limits=(x_bounds..., y_bounds..., z_bounds...))
set_theme!(merge(theme_black(), theme_latexfonts()))

us = [f(x, y, z)[1] for x in xs, y in ys, z in zs]
vs = [f(x, y, z)[2] for x in xs, y in ys, z in zs]
ws = [f(x, y, z)[3] for x in xs, y in ys, z in zs]

points = [Point3f(x, y, z) for x in xs, y in ys, z in zs]

# vecs = [Vec3f(f(x, y, z)/hypot(f(x, y, z)...)) for x in xs, y in ys, z in zs]
vecs_norm = [Vec3f(f(x, y, z)/hypot(f(x, y, z)...)) for x in xs, y in ys, z in zs]

lengths = [hypot(us[i], vs[i], ws[i])/hypot(maximum(us), maximum(vs), maximum(ws)) for i in eachindex(us)]
colors = [RGBf(l, 0.5, 0.5) for l in lengths]

arrows!(ax, vec(points), vec(vecs_norm), color=colors, arrowsize=0.025, lengthscale=0.1)

x_pts = [0.0]
y_pts = [5.0]
z_pts = [5.0]
Δt = 0.01
for t in 0:Δt:100
    x_next = x_pts[end] + f(x_pts[end], y_pts[end], z_pts[end])[1] * Δt
    y_next = y_pts[end] + f(x_pts[end], y_pts[end], z_pts[end])[2] * Δt
    z_next = z_pts[end] + f(x_pts[end], y_pts[end], z_pts[end])[3] * Δt
    append!(x_pts, x_next)
    append!(y_pts, y_next)
    append!(z_pts, z_next)
end
lines!(ax, x_pts, y_pts, z_pts, color=:white)

fig