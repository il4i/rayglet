try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

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
    "name" : "project name"
}

setup(**config)
