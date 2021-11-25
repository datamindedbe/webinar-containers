from glob import glob
from codecs import open
from os.path import basename
from os.path import splitext

from setuptools import find_packages, setup

name = "titanicpredictor"

# get the dependencies and installs
with open("requirements.txt", "r", encoding="utf-8") as f:
    requires = [x.strip() for x in f if x.strip()]

setup(
    name=name,
    version="0.1",
    description="A predictor for Titanic survivors",
    python_requires=">=3.9",
    packages=find_packages('src'),
    package_dir={'': 'src'},
    py_modules=[splitext(basename(path))[0] for path in glob('src/*.py')],
    include_package_data=True,
    install_requires=requires,
    author="DataMinded",
    entry_points={},
    zip_safe=False,
    classifiers=[
        "Programming Language :: Python :: 3.9",
    ],
    extras_require={
    },
)