try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

from Cython.Build import cythonize

directives = {'language_level': 3},

config = {
    "description" : "my project",
    "author" : "my name",
    "url" : "url to get it from",
    "download_url" : "url to download it from",
    "author_email" : "my e-mail",
    "version" : "0.1",
    "install_requires" : ['pytest', 'pyglet', 'Cython'],
    "packages" : ["NAME"],
    "scripts" : [],
    "ext_modules" : cythonize("src/*.pyx",
                              compiler_directives={'language_level' : 3}),
    "name" : "project name"
}

setup(**config)
