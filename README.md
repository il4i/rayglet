# Installing Python3 Packages

You will need to install some python3 packages to run/develop this program. The
full list is install_requires in setup.py.

The most common way to do this is to install pip (https://pypi.org/project/pip/)
and then run pip install <package name>.

Alternatively, you can find a dependency's page on pypi.org, download its
tar.gz, unzip, and then run
cd package_name
python3 setup.py build
sudo python3 setup.py install 
