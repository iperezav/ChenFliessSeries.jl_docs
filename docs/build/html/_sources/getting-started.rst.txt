.. _getting-started:

Getting-started
=====================

Installation
-----------------

To install the **CFSpy** package, you can use `pip <https://pip.pypa.io/en/stable/>`_. 
Run the following command in your terminal:

```
pip install cfspy
```

This will download and install the package along with its dependencies.
Make sure you have Python 3.6 or higher installed on your system.


Usage
-----------------

Once installed, you can start using the **CFSpy** package in your Python scripts.
Here is a simple example to get you started:

.. code-block:: python
   :linenos:

    from CFS import iter_int
    import numpy as np

    # parameters
    Ntrunc = 3  # truncation length
    t0 = 0  # initial time
    tf = 3  # final time
    dt = 0.001  # time step

    # inputs as arrays
    u1 = np.sin(t)
    u2 = np.cos(t)

    # input array
    u = np.vstack([u1, u2])

    # List of iterated integral
    Eu = iter_int(u,t0, tf, dt, Ntrunc)
    print(Eu)


This example demonstrates how to create the list of all iterated
integrals given input function at a specific time and truncation length.
For more detailed examples and advanced usage, 
please refer to the `examples <examples.html>`_ section of the documentation.