# -- Project information -----------------------------------------------------

project = 'ChenFliessSeries.jl'
copyright = '2026, Ivan Perez Avellaneda'
author = 'Ivan Perez Avellaneda'
release = '1.0.0'

# -- General configuration ---------------------------------------------------

extensions = [
    'sphinx_rtd_theme',
    'sphinx.ext.napoleon',
    'sphinx.ext.autodoc',
    'sphinx.ext.intersphinx',
    'sphinx.ext.autosummary',
    'sphinx.ext.mathjax',
    'sphinx.ext.graphviz',
    "sphinxcontrib.mermaid"
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

master_doc = 'index'

# -- HTML output -------------------------------------------------------------

html_theme = "sphinx_rtd_theme"

html_theme_options = {
    "style_external_links": True,
    "collapse_navigation": False,
    "sticky_navigation": True,
    "navigation_depth": 4,

    # Dark mode toggle (only works with RTD theme >= 1.3.0)
    "theme_switcher": True,
    "switcher": {
        "json_url": "_static/switcher.json",
        "version_match": "latest",
    },

    "style_nav_header_background": "#0d6efd",
}

html_static_path = ['_static']
html_js_files = ["theme_switcher.js"]

pygments_style = 'monokai'
numfig = True
math_numfig = True

def setup(app):
    app.add_css_file('custom.css')