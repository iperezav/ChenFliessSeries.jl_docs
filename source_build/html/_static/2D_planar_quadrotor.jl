using Symbolics
using LinearAlgebra
using ChenFliessSeries

# ---------------------------------------------------------
# 1. Lie derivatives
# ---------------------------------------------------------

@variables x[1:6]
x_vec = x

Ntrunc = 4                # truncation depth
h = x[1]                  # output: horizontal position

# Physical parameters
gg   = 9.81
m    = 0.18
Ixx  = 0.00025
L    = 0.086

# Vector fields g0, g1, g2
g = hcat(
    [x[4], x[5], x[6], 0, -gg, 0],
    [0, 0, 0, 1/m*sin(x[3]), 1/m*cos(x[3]), -L/Ixx],
    [0, 0, 0, 1/m*sin(x[3]), 1/m*cos(x[3]),  L/Ixx]
)

# Initial state
x_val = [0.0, 0.0, 0.1, 0.0, 0.0, 0.0]

# Build evaluator for all Lie derivatives up to Ntrunc
f_L = build_lie_evaluator(h, g, x_vec, Ntrunc)

# Evaluate Lie derivatives at x_val
L_eval = f_L(x_val)

# ---------------------------------------------------------
# 2. Iterated integrals
# ---------------------------------------------------------

dt = 0.001
t = 0:dt:0.1

u0 = one.(t)
u1 = sin.(t)
u2 = cos.(t)

utemp = vcat(u0', u1', u2')

E = iter_int(utemp, dt, Ntrunc)

# ---------------------------------------------------------
# 3. Chen–Fliess series
# ---------------------------------------------------------

y_cf = x_val[1] .+ vec(L_eval' * E)   # output h = x1


# ---------------------------------------------------------
# 4. Comparison with ODE simulation
# ---------------------------------------------------------

using DifferentialEquations
using Plots

function twodquad!(dx, x, p, t)
    u1 = sin(t)
    u2 = cos(t)

    dx[1] = x[4]
    dx[2] = x[5]
    dx[3] = x[6]
    dx[4] = 1/m*sin(x[3])*(u1+u2)
    dx[5] = -gg + (1/m*cos(x[3]))*(u1+u2)
    dx[6] = (L/Ixx)*(u2-u1)
end

x0 = x_val
tspan = (0.0, 0.1)

prob = ODEProblem(twodquad!, x0, tspan)
sol = solve(prob, Tsit5(), saveat = t)

x1_ode = sol[1, :]

# Plot comparison
plot(t, x1_ode,
    label="ODE solution x₁(t)",
    linewidth=3,
    color=:blue)

plot!(t, y_cf,
    label="Chen–Fliess (Ntrunc = 3)",
    linewidth=3,
    linestyle=:dash,
    color=:red)

xlabel!("Time")
ylabel!("Value")
title!("ODE vs Chen–Fliess Approximation")
plot!(grid = true)