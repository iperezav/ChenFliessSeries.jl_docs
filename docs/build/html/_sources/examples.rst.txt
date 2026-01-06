.. _examples-examples:

Examples
=====================
This section provides practical examples of how to 
use the **CFSpy** package for various computations related to Chen-Fliess series.

Lotka-Volterra
-----------------

.. code-block:: python
   :linenos:

    from CFS import iter_int, iter_lie, single_iter_int, single_iter_lie

    import numpy as np
    from scipy.integrate import solve_ivp
    import matplotlib.pyplot as plt
    import sympy as sp

    # Define the Lotka-Volterra system
    def system(t, x, u1_func, u2_func):
        x1, x2 = x
        u1 = u1_func(t)
        u2 = u2_func(t)
        dx1 = -x1*x2 +  x1 * u1
        dx2 = x1*x2 - x2* u2
        return [dx1, dx2]

    # Input 1
    def u1_func(t):
        return np.sin(t)

    # Input 2
    def u2_func(t):
        return np.cos(t)

    # Initial condition
    x0 = [1/3,2/3]

    # Time range
    t0 = 0
    tf = 3
    dt = 0.001
    t_span = (t0, tf)

    # Simulation of the system
    solution = solve_ivp(system, t_span, x0, args=(u1_func, u2_func), dense_output=True)

    # Partition of the time interval
    t = np.linspace(t_span[0], t_span[1], int((tf-t0)//dt+1))
    y = solution.sol(t)

    # Define the symbolic variables
    x1, x2 = sp.symbols('x1 x2')
    x = sp.Matrix([x1, x2])


    # Define the system symbolically
    g = sp.transpose(sp.Matrix([[-x1*x2, x1*x2], [x1, 0], [0, - x2]]))

    # Define the output symbolically
    h = x1

    # The truncation of the length of the words that index the Chen-Fliess series
    Ntrunc = 4

    # Coefficients of the Chen-Fliess series evaluated at the initial state
    Ceta = np.array(iter_lie(h,g,x,Ntrunc).subs([(x[0], 1/3),(x[1], 2/3)]))

    # inputs as arrays
    u1 = np.sin(t)
    u2 = np.cos(t)

    # input array
    u = np.vstack([u1, u2])

    # List of iterated integral
    Eu = iter_int(u,t0, tf, dt, Ntrunc)

    # Chen-Fliess series
    F_cu = x0[0]+np.sum(Ceta*Eu, axis = 0)

    # Graph of the output and the Chen-Fliess series
    plt.figure(figsize = (12,5))
    plt.plot(t, y[0].T)
    plt.plot(t, F_cu, color='red', linewidth=5, linestyle = '--', alpha = 0.5)
    plt.xlabel('$t$')
    plt.ylabel('$x_1$')
    plt.legend(['Output of the system','Chen-Fliess series'])
    plt.grid()
    plt.show()

.. image:: https://raw.githubusercontent.com/iperezav/CFSpy/main/examples/output_chenfliess.png
   :alt: iter_int(), iter_lie()
   :align: center
   :width: 600px
   :height: 300px
