.. _getting-started:

Getting-started
=====================

Installation
-----------------

To install the **ChenFliessSeries.jl** package, 
run the following command in your terminal:

Using the Julia REPL's Pkg mode
```
julia> ]
pkg> add ChenFliessSeries
```
Or using the Pkg module in the standard REPL
```
julia> using Pkg
julia> Pkg.add(“ChenFliessSeries”)
```

This will download and install the package along with its dependencies.
Make sure you have Julia 1.12.3 or higher installed on your system.


Usage
-----------------

Once installed, you can start using the **ChenFliessSeries.jl** package in your Julia scripts.
Here is a simple example to get you started:

.. code-block:: julia
   :linenos:

    # Time step
    dt = 0.001  

    # Time interval
    t = 0:dt:0.1  

    # Inputs
    u0 = one.(t)
    u1 = sin.(t)   
    u2 = cos.(t)

    # Stack of the inputs
    utemp = vcat(u0', u1', u2')   

    # Iterated integrals
    E = iter_int(utemp, dt, Ntrunc)   



This example demonstrates how to create the list of all iterated
integrals given input function at a specific time and truncation length.
For more detailed examples and advanced usage, 
please refer to the `examples <examples.html>`_ section of the documentation.