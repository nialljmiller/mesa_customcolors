# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# http://www.sphinx-doc.org/en/master/config

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys

sys.path.insert(0, os.path.abspath("./_ext/"))


# -- Project information -----------------------------------------------------

project = "MESA"
copyright = "2025, The MESA Team"
author = "The MESA Team"
language = "en"
version = "main"
release = version


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    "sphinx.ext.autosectionlabel",
    "sphinx.ext.extlinks",
    "defaults2rst",
    "sphinx_copybutton",
    "sphinx_design",
    "sphinx_tags",
    "sphinxemoji.sphinxemoji",
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ["_templates"]

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
# html_theme = "sphinx_rtd_theme"
html_theme = "sphinx_book_theme"

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ["_static"]

# -- Additional configuration ------------------------------------------------

# Ensure that autosectionlabel will produce unique names
autosectionlabel_prefix_document = True
# Go to depth 3 so options in defaults files get labels
autosectionlabel_maxdepth = 6

# sphinx_rtd options
# html_theme_options = {
#     "collapse_navigation": True,
#     "sticky_navigation": True,
#     "navigation_depth": 4,
#     "includehidden": True,
#     "titles_only": False,
#     "logo_only": True,
# }

# sphinx_book_theme options
html_theme_options = {
    "path_to_docs": "docs/source",
    "collapse_navigation": True,
    "navigation_depth": 4,
    "repository_url": "https://github.com/MESAHub/mesa",
    "use_repository_button": True,
    "use_edit_page_button": True,
    "use_source_button": True,
    "icon_links": [
        {
            "name": "Official Release Version",
            "url": "https://zenodo.org/records/13353788",
            "icon": "fa-solid fa-star",
        },
        {
            "name": "MESA SDK",
            "url": "http://user.astro.wisc.edu/~townsend/static.php?ref=mesasdk",
            "icon": "fa-solid fa-gears",
        },
        {
            "name": "Mailing List",
            "url": "https://lists.mesastar.org/mailman/listinfo/mesa-users",
            "icon": "fa-solid fa-envelope",
        },
        {
            "name": "GitHub",
            "url": "https://github.com/MESAHub/mesa",
            "icon": "fa-brands fa-github",
        },
    ],
}

# sphinx_tags options
tags_create_tags = True
tags_overview_title = "Test Problem tags"
tags_page_title = "Tags"
tags_page_header = "Test problems with this tag"
tags_create_badges = True
tags_badge_colors = {
    "star": "primary",
    "binary": "primary",
    "high-mass": "secondary",
    "low-mass": "secondary",
}

# Set master doc
master_doc = "index"

# Set logo
html_logo = "mesa-logo.png"
html_favicon = "mesa-favicon.png"

# Set canonical URL from the Read the Docs Domain
html_baseurl = os.environ.get("READTHEDOCS_CANONICAL_URL", "")

html_context = {
    "display_github": True,  # Integrate GitHub
    "github_user": "MESAHub",  # Username
    "github_repo": "mesa",  # Repo name
    "github_version": "main",  # Version
    "conf_py_path": "/docs/source/",  # Path in the checkout to the docs root
}

# Tell Jinja2 templates the build is running on Read the Docs
html_context["READTHEDOCS"] = os.environ.get("READTHEDOCS", "") == "True"


# Override theme stylesheet
html_css_files = [
    "theme_overrides.css",  # overrides for wide tables in RTD theme
]

# standard substitutions
rst_prolog = r"""
.. |MESA I| replace:: `MESA I <https://ui.adsabs.harvard.edu/abs/2011ApJS..192....3P/abstract>`__
.. |MESA II| replace:: `MESA II <https://ui.adsabs.harvard.edu/abs/2013ApJS..208....4P/abstract>`__
.. |MESA III| replace:: `MESA III <https://ui.adsabs.harvard.edu/abs/2015ApJS..220...15P/abstract>`__
.. |MESA IV| replace:: `MESA IV <https://ui.adsabs.harvard.edu/abs/2018ApJS..234...34P/abstract>`__
.. |MESA V| replace:: `MESA V <https://ui.adsabs.harvard.edu/abs/2019ApJS..243...10P/abstract>`__
.. |MESA VI| replace:: `MESA V <https://ui.adsabs.harvard.edu/abs/2023ApJS..265...15J/abstract>`__
.. |Msun| replace:: :math:`{\rm M}_\odot`
.. |Lsun| replace:: :math:`{\rm L}_\odot`
.. |Rsun| replace:: :math:`{\rm R}_\odot`
.. |Teff| replace:: :math:`T_{\rm eff}`
.. |logRho| replace:: :math:`\log(\rho/\rm g\,cm^{-3})`
.. |logT| replace:: :math:`\log(T/\rm K)`
.. |chi^2| replace:: :math:`\chi^2`
.. |gpercm3| replace:: :math:`\rm g\,cm^{-3}`
"""

# set default highlighting language
highlight_language = "fortran"

# sphinx.extlinks configuration
extlinks = {
    "wiki": ("https://en.wikipedia.org/wiki/%s", None),
    "git": ("https://github.com/%s", None),
}
