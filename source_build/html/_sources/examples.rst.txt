.. _examples-examples:

Examples
=====================

This section provides practical demonstrations of how to use
**ChenFliessSeries.jl** for computing iterated integrals, Lie derivatives,
and truncated Chen–Fliess series for nonlinear control‑affine systems.

Each example illustrates a complete workflow:

1. Define vector fields and outputs  
2. Compute Lie derivatives  
3. Compute iterated integrals  
4. Assemble the truncated Chen–Fliess series  
5. Compare with a numerical ODE solution  

Two representative systems are shown below:  
a 2D planar quadrotor and a nonlinear pendulum.

------------------------------------------------------------
2D Planar Quadrotor
------------------------------------------------------------

This example demonstrates how to compute Lie derivatives, iterated integrals,
and a truncated Chen–Fliess approximation for a simplified planar quadrotor.


System dynamics
-----------------

We consider the standard control–affine pendulum model:

.. math::

    \begin{aligned}
    \dot{x}_1 &= x_4, \\
    \dot{x}_2 &= x_5, \\
    \dot{x}_3 &= x_6, \\
    \dot{x}_4 &= \frac{1}{m} \sin(x_3) (u_1(t) + u_2(t)), \\
    \dot{x}_5 &= -g + \frac{1}{m} \cos(x_3)(u_1(t) + u_2(t)), \\
    \dot{x}_6 &= \frac{L}{I_{xx}} (u_2(t)-u_1(t)) 
    \end{aligned}

with output

.. math::

    y = h(x) = x_1.

This can be written in control–affine form

.. math::

    \dot{x} = g_0(x) + g_1(x) u_1(t) + g_2(x) u_2(t),

where

.. math::

    g_0(x) = \begin{bmatrix} x_4 \\ x_5 \\ x_6 \\ 0 \\ 0 \\ 0] \end{bmatrix},
    \quad
    g_1(x) = \begin{bmatrix} 0 \\ 0 \\ 0 \\ \frac{1}{m} \sin(x_3) \\ \frac{1}{m} \cos(x_3) \\ \frac{-L}{I_{xx}} \end{bmatrix},
    \quad
    g_2(x) = \begin{bmatrix} 0 \\ 0 \\ 0 \\ \frac{1}{m} \sin(x_3) \\ \frac{1}{m} \cos(x_3) \\ \frac{L}{I_{xx}} \end{bmatrix}.


Defining the system in Julia
-------------------------------

.. code-block:: julia
   :linenos:

    using Symbolics
    using LinearAlgebra
    using ChenFliessSeries

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


Input signal
---------------

.. code-block:: julia
   :linenos:

    dt = 0.001
    t = 0:dt:0.1

    u0 = one.(t)
    u1 = sin.(t)
    u2 = cos.(t)

    utemp = vcat(u0', u1', u2')


Computing iterated integrals
-------------------------------


.. code-block:: julia
   :linenos:

    E = iter_int(utemp, dt, Ntrunc)


Computing Lie derivatives
----------------------------


.. code-block:: julia
   :linenos:

    # Initial state
    x_val = [0.0, 0.0, 0.1, 0.0, 0.0, 0.0]

    # Build evaluator for all Lie derivatives up to Ntrunc
    f_L = build_lie_evaluator(h, g, x_vec, Ntrunc)

    # Evaluate Lie derivatives at x_val
    L_eval = f_L(x_val)

Assembling the truncated Chen-Fliess series
----------------------------------------------


.. code-block:: julia
   :linenos:

    y_cf = x_val[1] .+ vec(L_eval' * E)   # output h = x1

Simulating the true 2D planar quadrotor dynamics
-----------------------------------------------------


.. code-block:: julia
   :linenos:

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
    

Comparison plot
--------------------


.. code-block:: julia
   :linenos:

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

.. image:: https://raw.githubusercontent.com/iperezav/ChenFliessSeries.jl/main/assets/Chen-Fliess-series_quadrotor.png
   :alt: Chen–Fliess series quadrotor example
   :align: center
   :width: 600px
   :height: 300px


------------------------------------------------------------
Pendulum Example
------------------------------------------------------------

This example illustrates how to compute a truncated Chen–Fliess series
for a nonlinear pendulum with torque input and compare it with the true
ODE solution.

System dynamics
---------------------

We consider the standard control–affine pendulum model:

.. math::

    \dot{z}_1 = z_2, \qquad
    \dot{z}_2 = -\sin(z_1) + u(t),

with output

.. math::

    y = h(z) = z_1.

This can be written in control–affine form

.. math::

    \dot{z} = g_0(z) + g_1(z) u(t),

where

.. math::

    g_0(z) = \begin{bmatrix} z_2 \\ -\sin(z_1) \end{bmatrix},
    \qquad
    g_1(z) = \begin{bmatrix} 0 \\ 1 \end{bmatrix}.

A visual summary:

.. code-block:: text

        θ (angle)
        ↑
        │      • mass
        │     /
        │    /
        │   O──────→ torque u(t)
        │
        └──────────────→ time

Defining the system in Julia
-------------------------------

.. code-block:: julia
    :linenos:

    using ChenFliessSeries
    using Symbolics

    @variables z[1:2]
    z_vec = z

    g = hcat(
        [z[2], -sin(z[1])],
        [0, 1],
        )
    
    h = z[1]

Input signal
-----------------

.. code-block:: julia
    :linenos:

    dt = 0.001
    t = 0:dt:2.0

    u0 = one.(t)
    u1 = 0.5 .* sin.(2t)

    utemp = vcat(u0', u1')

Computing iterated integrals
--------------------------------

.. code-block:: julia
    :linenos:

    Ntrunc = 5
    E = iter_int(utemp, dt, Ntrunc)

Computing Lie derivatives
-----------------------------

.. code-block:: julia
    :linenos:

    z_val = [0.5, 0.0]
    f_L = build_lie_evaluator(h, g, z_vec, Ntrunc)
    L_eval = f_L(z_val) 

Assembling the truncated Chen–Fliess series
----------------------------------------------

.. code-block:: julia
    :linenos:

    Fc = chen_fliess_output(Ntrunc, z_val, g, h, z_vec, dt, u)

Simulating the true pendulum dynamics
-----------------------------------------

.. code-block:: julia
    :linenos:

    using OrdinaryDiffEq

    function pendulum!(dz, z, p, t)

        u = 0.5*sin.(2t)

        dz[1] = z[2]
        dz[2] = -sin(z[1]) + u
    end

    z0 = z_val
    prob = ODEProblem(pendulum!, z0, (0.0, 2.0))
    sol = solve(prob, Tsit5(), dt=dt)

    y_true = h.(sol.(t))

Comparison plot
-------------------

.. code-block:: julia
    :linenos:

    using Plots

    plot(t, y_true, label="True pendulum output", lw=2)
    plot!(t, Fc, label="Chen–Fliess (N = $Ntrunc)", lw=2)
    xlabel!("t")
    ylabel!("θ(t)")
    title!("Pendulum: Chen–Fliess approximation vs ODE solution")

Error analysis
-------------------

.. code-block:: julia
    :linenos:

    err = abs.(y_true .- Fc)
    plot(t, err, label="|y_true - F_c|", lw=2)
    xlabel!("t")
    ylabel!("Error")
    title!("Approximation error")

Interpretation
-------------------

For small inputs and short time horizons, the truncated Chen–Fliess
series provides an accurate approximation of the pendulum’s output.
The error increases with:

- truncation depth,
- input amplitude,
- nonlinearity (large angles),
- and time horizon.

This example demonstrates how Chen–Fliess expansions capture nonlinear
dynamics through iterated integrals and Lie derivatives, providing a
powerful tool for analysis, approximation, and reachability.