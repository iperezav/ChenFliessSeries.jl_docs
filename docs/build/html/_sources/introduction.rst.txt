

Introduction
========================

The **CFSpy** Python package is developed to compute numerically the 
Chen-Fliess series representation of the output of
nonlinear input-output control systems. These systems are described by

.. math::
    \begin{eqnarray}
    \dot{z} &=& g_0(z) + \sum_{i = 1}^{m} g_i(z) u_i\\
    y &=& h(z)
    \end{eqnarray}


where the vector fields :math:`g_i` and the output function :math:`h` are analytic.
The Chen-Fliess series has the form:

.. math::
    \begin{eqnarray}
    F_c[u](t) = \sum_{\eta \in X^*} (c, \eta) E_{\eta}[u](t)
    \end{eqnarray}

Here, :math:`X^*` is the set of all words over the alphabet 
:math:`X = \{x_0, \ldots, x_m\}`, :math:`(c, \eta)` is the coefficient corresponding to the word 
:math:`\eta` in the generating series :math:`c`, and :math:`E_{\eta}[u](t)` is the iterated integral
corresponding to the word :math:`\eta` and the input function :math:`u`.
The Chen-Fliess series represents the output of the system when 
certain conditions are met. 