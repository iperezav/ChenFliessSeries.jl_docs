.. _getting-started:

Getting Started
=====================

This chapter provides a high-level overview of how to begin using
**ChenFliessSeries.jl**. It introduces the core workflow, explains the
main concepts, and walks through the essential steps for computing
Chen–Fliess expansions in practice.

The goal is to give you a clear mental model first, and then guide you
through concrete examples.

Contents
--------

- :ref:`installation`
- :ref:`basic-usage`
- :ref:`iterated-integrals`
- :ref:`vector-fields`
- :ref:`lie-derivatives`
- :ref:`truncated-series`
- :ref:`ode-comparison`
- :ref:`pitfalls`
- :ref:`more-examples`


.. _installation:

Installation
-----------------

To install the **ChenFliessSeries.jl** package, run the following command
in your terminal.

Using the Julia REPL's Pkg mode:

.. code-block:: bash
    :linenos:

    julia> ]
    pkg> add ChenFliessSeries

Or using the Pkg module in the standard REPL:

.. code-block:: bash
    :linenos:

    julia> using Pkg
    julia> Pkg.add("ChenFliessSeries")

This will download and install the package along with its dependencies.
Make sure you have Julia 1.12.3 or higher installed on your system.

Quick sanity check:

.. code-block:: julia
    :linenos:

    using ChenFliessSeries
    @info "ChenFliessSeries.jl loaded successfully!"


.. _basic-usage:

Basic Usage (High-Level Overview)
-------------------------------------

Once installed, **ChenFliessSeries.jl** enables you to compute the
building blocks of the Chen–Fliess expansion:

1. **Iterated integrals** of the input  
2. **Lie derivatives** of the output along the vector fields  
3. **Chen–Fliess coefficients** :math:`(c,\eta)`  
4. **Truncated Chen–Fliess series** :math:`F_c^{N}[u](t)`  
5. **Comparison with the true system output**

A typical workflow looks like this:

.. mermaid::

    flowchart TD
        classDef step fill:#f2f2f2,stroke:#333,stroke-width:1px,rx:6px,ry:6px,color:black;

        U["Inputs <br/> $$\ u(t)$$"]:::step
        E["Iterated integrals<br/> $$\ E^N_\eta[u](t)$$"]:::step
        G["Vector fields<br/> $$\ g_i$$"]:::step
        L["Lie derivatives<br/> $$\ L_\eta h$$"]:::step
        F["Chen–Fliess series<br/> $$\ F_c^N[u](t)$$"]:::step
        O["Output of the system<br/>$$\ h(t)$$"]:::step

        G --> L --> F
        O --> L     
        U --> E --> F
         



The sections below walk through each step in detail.


.. _iterated-integrals:

Computing iterated integrals
-------------------------------------

To compute the iterated integrals :math:`E_\eta[u](t)`,
you must define:

- time interval :math:`[0,t_f]`,
- input function :math:`u(t)`,
- the integration step :math:`dt`.
- truncation length :math:`N`

.. code-block:: julia
   :linenos:

    using ChenFliessSeries

    dt = 0.001
    t = 0:dt:0.1

    u0 = one.(t)
    u1 = sin.(t)
    u2 = cos.(t)

    utemp = vcat(u0', u1', u2')   # shape: (m+1, length(t))

    Ntrunc = 4
    E = iter_int(utemp, dt, Ntrunc)

This computes all iterated integrals :math:`E_\eta[u](t)` for
:math:`|\eta| \le N`.

The algorithm of the `iter_int` function is based on Chen's identity
which translates numerically to 

.. math::
    :label: eq:cfs

    \begin{aligned}
    E_{X^k}[u](t)=\int _0^t u(t)\otimes E_{X^{k-1}}[u](t) d\tau .
    \end{aligned}

where :math:`u(t)` is the matrix of inputs stacked horizontally,
:math:`E_{X^k}[u](t)` is the matrix that stacks horizontally the iterated integrals 
and the tensor symbol :math:`\otimes` represents 
the `column-wise Kronecker product <https://en.wikipedia.org/wiki/Khatri%E2%80%93Rao_product>`_ .

The outline of the calculation of the algorithm follows the workflow:

.. mermaid::

    flowchart TD
        classDef step fill:#f2f2f2,stroke:#333,stroke-width:1px,rx:6px,ry:6px,color:black;
        classDef calc fill:#e8f0ff,stroke:#333,stroke-width:1px,rx:6px,ry:6px,color:black;
        classDef loop fill:#fff4d6,stroke:#333,stroke-width:1px,rx:6px,ry:6px,color:black;

        A["Start<br/><span> $$\ ( u_{\text{temp}}, dt, N_{\text{trunc}})$$</span>"]:::step

        H["Compute first-order integrals: <span> $$\ E_{X^1}[u](t) $$</span>"]:::calc

        I{"Loop i = 1 to Ntrunc-1"}:::loop

        K["<span> $$\ \text{Etemp} = u(t)\otimes E_{X^{i}}[u](t) $$</span>"]:::calc
        M["Compute: <span> $$\ E_{X^{i+1}}[u](t) = \int _0^t \text{Etemp} d\tau $$</span>"]:::calc
        N["Store <span> $$\ E_{X^{i+1}}[u](t) $$</span>"]:::step

        O["Return the integral block"]:::step

        %% Connections
        A --> H --> I
        I --> K  --> M
        M --> N --> I
        I --> O


.. _vector-fields:

Defining vector fields and outputs
-------------------------------------

To compute Chen–Fliess coefficients :math:`(c,\eta) = L_\eta h`,
you must define:

- the drift vector field :math:`g_0(z)`,
- the controlled vector fields :math:`g_i(z)`,
- the output function :math:`h(z)`.

Example:

.. code-block:: julia
    :linenos:

    using Symbolics
    
    @variables x[1:6]
    z_vec = x

    Ntrunc = 4

    h = x[1]

    # parameters
    gg     = 9.81   # Gravitational acceleration (m/s^2)
    m     = 0.18    # Mass (kg)
    Ixx   = 0.00025 # Mass moment of inertia (kg*m^2)
    L     = 0.086   # Arm length (m)


    g = hcat(
        [x[4], x[5], x[6], 0, -gg, 0],
        [0, 0, 0, 1/m*sin(x[3]), 1/m*cos(x[3]), -L/Ixx],
        [0, 0, 0, 1/m*sin(x[3]), 1/m*cos(x[3]), L/Ixx]
    )


.. _lie-derivatives:

Computing Lie derivatives
-------------------------------------

Lie derivatives encode the geometric structure of the system.

.. code-block:: julia
    :linenos:

    x_val = [0.5, 0.0, 0.1, 0.0, 0.0, 0.0]   # make it Float64 to avoid promotion issues

    # initial evaluator for Ntrunc = 4
    f_L = build_lie_evaluator(h, g, x_vec, Ntrunc)
    L_eval = f_L(x_val)   # Vector{Float64}, no Symbolics anywhere


Similarly to the iterated integrals, the outline of the calculation of the algorithm follows the workflow:

.. mermaid::

    flowchart TD
        classDef step fill:#f2f2f2,stroke:#333,stroke-width:1px,rx:6px,ry:6px,color:black;
        classDef calc fill:#e8f0ff,stroke:#333,stroke-width:1px,rx:6px,ry:6px,color:black;
        classDef loop fill:#fff4d6,stroke:#333,stroke-width:1px,rx:6px,ry:6px,color:black;

        A["Start<br/><span> $$\ ( g_i(z), h(z),  N_{\text{trunc}})$$</span>"]:::step

        H["Compute first-order Lie derivatives: <span> $$\ L_{X^1}h(z) $$</span>"]:::calc

        I{"Loop i = 1 to Ntrunc-1"}:::loop

        K["<span> $$\ \text{Ltemp} = \frac{\partial}{\partial z}L_{X^i}h(z) $$</span>"]:::calc
        M["Compute: <span> $$\  g\otimes \text{Ltemp} $$</span>"]:::calc
        N["Store <span> $$\ L_{X^{i+1}}h(z) $$</span>"]:::step

        O["Return the Lie derivative block"]:::step

        %% Connections
        A --> H --> I
        I --> K  --> M
        M --> N --> I
        I --> O


.. _truncated-series:

Computing truncated Chen–Fliess series
-----------------------------------------

Once iterated integrals and Lie derivatives are available, you can
assemble the truncated Chen–Fliess series:

.. code-block:: julia
    :linenos:

    Fc = chen_fliess_series(h, g, utemp, dt, Ntrunc)

This returns a numerical approximation of

.. math::

    F_c^{N}[u](t) = \sum_{|\eta| \le N} (c, \eta)\, E_\eta[u](t).


.. _ode-comparison:

Comparing with ODE simulation
-------------------------------------

To validate the approximation, compare it with the true system output.

.. code-block:: julia
    :linenos:
    
    using DifferentialEquations

    function twodquad!(dx, x, p, t)
        # input u1(t)
        u1 = sin(t)          # scalar, t is a Float64 here
        u2 = cos(t)

        # same dynamics as symbolic g, but numeric
        dx[1] = x[4]
        dx[2] = x[5]
        dx[3] = x[6]
        dx[4] = 1/m*sin(x[3])*(u1+u2)
        dx[5] = -gg + (1/m*cos(x[3]))*(u1+u2)
        dx[6] = (L/Ixx)*(u2-u1)
    end

    x0 = [0.0, 0.0, 0.1, 0.0, 0.0, 0.0]
    tspan = (0.0, 0.1)

    prob = ODEProblem(twodquad!, x0, tspan)
    sol = solve(prob, Tsit5(), saveat = t)

    x1_ode = sol[1, :]   # extract x₂(t), since h = x₂

    y_true = x1_ode
    y_cfs  = Fc


.. _pitfalls:

Common pitfalls
------------------

- **Mismatched dimensions**: Inputs must have shape `(m+1, length(t))`.
- **Transpose required**: Use `vcat(u0', u1', ...)`.
- **Large truncation depth**: Word count grows combinatorially.
- **Vector fields should be symbolic** for compliance.
- **Indexing inside ODE solvers** must match the time grid.


.. _more-examples:

More examples
-----------------

For more detailed examples and advanced usage,
see the `examples <examples.html>`_ section of the documentation.