.. ChenFliessSeries.jl documentation master file.

.. raw:: html

    <div align="center">
        <img src="_static/CFSjul_logo_2.png" alt="ChenFliessSeries.jl logo" width="360">
    </div>
   
   <br>

   <br>

Documentation
====================================

.. raw:: html

    <p align="center">
      <a href="https://github.com/iperezav/ChenFliessSeries.jl/releases">
        <img src="https://img.shields.io/github/v/release/iperezav/ChenFliessSeries.jl?style=for-the-badge&color=0d6efd&label=Version" />
      </a>
      <a href="https://chenfliessseriesjl-docs.readthedocs.io/en/latest/">
        <img src="https://img.shields.io/badge/Docs-Stable-28a745?style=for-the-badge" />
      </a>
      <a href="https://github.com/iperezav/ChenFliessSeries.jl/actions">
        <img src="https://img.shields.io/github/actions/workflow/status/iperezav/ChenFliessSeries.jl/CI.yml?style=for-the-badge&label=CI" />
      </a>
      <a href="https://github.com/iperezav/ChenFliessSeries.jl/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/iperezav/ChenFliessSeries.jl?style=for-the-badge&color=6c757d" />
      </a>
    </p>

.. raw:: html

    <div align="center" style="margin-top: 1.5rem; margin-bottom: 1.5rem;">
        <h2 style="font-weight: 600;">Fast, Recursive, and Symbolic Chen–Fliess Series in Julia</h2>
        <p style="font-size: 1.1rem; max-width: 650px; margin: auto;">
            A lightweight, high‑performance Julia package for computing iterated integrals,
            Lie derivatives, and truncated Chen–Fliess expansions for nonlinear control‑affine systems.
        </p>
    </div>

Features at a glance
------------------------

.. raw:: html

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1rem; margin-top: 1rem; margin-bottom: 1.5rem;">

      <div style="border: 1px solid #2b303b; border-radius: 8px; padding: 0.75rem 1rem;">
        <h4>Iterated integrals</h4>
        <p>Compute all iterated integrals up to a chosen word length using recursive schemes based on Chen’s identity.</p>
      </div>

      <div style="border: 1px solid #2b303b; border-radius: 8px; padding: 0.75rem 1rem;">
        <h4>Lie derivatives</h4>
        <p>Generate Lie derivatives indexed by words in the free monoid, symbolically or numerically.</p>
      </div>

      <div style="border: 1px solid #2b303b; border-radius: 8px; padding: 0.75rem 1rem;">
        <h4>Truncated Chen–Fliess series</h4>
        <p>Assemble truncated series and compare them against ODE simulations for validation and benchmarking.</p>
      </div>

      <div style="border: 1px solid #2b303b; border-radius: 8px; padding: 0.75rem 1rem;">
        <h4>Minimal dependencies</h4>
        <p>Built on top of <code>Symbolics.jl</code> and <code>LinearAlgebra</code> for a lean, composable stack.</p>
      </div>

    </div>

.. sidebar:: What are Chen–Fliess series?

   Chen–Fliess series provide an input–output representation of analytic
   nonlinear control‑affine systems.  
   They express the output as a formal power series whose coefficients are
   Lie derivatives of the output function and whose terms are iterated
   integrals of the input.

   Formally:

   .. math::

      F_c[u](t) = \sum_{\eta \in X^*} (c,\eta)\, E_\eta[u](t),

   where:

   - :math:`\eta` is a word over the alphabet :math:`X = \{x_0,\ldots,x_m\}`,
   - :math:`(c,\eta)` is the coefficient given by a Lie derivative,
   - :math:`E_\eta[u](t)` is the iterated integral associated with :math:`\eta`.

   These series play a central role in nonlinear control theory, system
   approximation, and operator‑theoretic analysis.

Overview
--------

**ChenFliessSeries.jl** implements efficient numerical and symbolic tools for:

- generating all iterated integrals indexed by words up to a chosen length,
- computing Lie derivatives associated with words in the free monoid,
- assembling truncated Chen–Fliess series,
- validating approximations against ODE simulations.

The implementation is based on Chen’s identity, which provides recursive
relations between iterated integrals and Lie derivatives, significantly
reducing redundant computation.

This package is the first publicly available open‑source implementation of
these tools in the Julia ecosystem, relying only on `Symbolics.jl` and
`LinearAlgebra.jl` for minimal and efficient dependencies.


Why Julia?
----------------

**ChenFliessSeries.jl** is written in Julia to leverage:

- **High performance**: JIT compilation and type specialization enable
  tight inner loops for iterated integrals and Lie derivatives.
- **Multiple dispatch**: Natural expression of different system types,
  vector field representations, and numeric backends.
- **Symbolic–numeric synergy**: Seamless integration with `Symbolics.jl`
  for symbolic Lie derivatives and `LinearAlgebra` for efficient evaluation.
- **Interactive workflows**: Notebooks and REPL‑driven exploration make
  it easy to prototype, visualize, and benchmark Chen–Fliess expansions.


Citing this package
------------------------

If you use **ChenFliessSeries.jl** in academic work, please cite it as:

.. code-block:: bibtex

    @misc{ChenFliessSeriesJL,
      title        = {ChenFliessSeries.jl: A Julia package for computing Chen-Fliess series},
      author       = {Perez Avellaneda, Ivan},
      year         = {2026},
      url          = {https://github.com/iperezav/ChenFliessSeries.jl},
      note         = {Julia package version 1.0.0}
    }

A `CITATION.bib <_static/CITATION.bib>`_ file is also included in the repository.


Example gallery
-------------------

.. raw:: html

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1rem; margin-top: 1rem;">

      <div style="border: 1px solid #2b303b; border-radius: 8px; padding: 0.5rem;">
        <img src="_static/examples/pendulum.png" alt="Pendulum Chen–Fliess approximation" style="width: 100%; border-radius: 4px;">
        <p style="margin-top: 0.5rem;">
        <a href="https://chenfliessseriesjl-docs.readthedocs.io/en/latest/examples.html#pendulum-example">
        <strong>Nonlinear pendulum</strong>
        </a>
        <br>
        Chen–Fliess approximation vs ODE solution.
        </p>
      </div>

      <div style="border: 1px solid #2b303b; border-radius: 8px; padding: 0.5rem;">
        <img src="_static/examples/quadcopter.png" alt="Quadrotor Chen–Fliess approximation" style="width: 100%; border-radius: 4px;">
        <p style="margin-top: 0.5rem;">
        <a href="https://chenfliessseriesjl-docs.readthedocs.io/en/latest/examples.html#d-planar-quadrotor">
        <strong>2D Planar quadrotor</strong>
        </a>
        <br>
        Control‑affine model and truncated series behavior.
        </p>
      </div>

      <!--<div style="border: 1px solid #2b303b; border-radius: 8px; padding: 0.5rem;">
        <img src="_static/examples/reachability_cfs.png" alt="Reachability via Chen–Fliess" style="width: 100%; border-radius: 4px;">
        <p style="margin-top: 0.5rem;"><strong>Reachability</strong><br>Using Chen–Fliess expansions for reachable set approximations.</p>
      </div>-->

    </div>

Contents
--------

.. toctree::
   :maxdepth: 3

   introduction
   getting-started
   examples
   contributing