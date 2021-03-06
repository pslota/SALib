#!/usr/bin/env sh
# This script is meant to be called by the "install" step defined in
# .travis.yml. See http://docs.travis-ci.com/ for more details.
# The behavior of the script is controlled by environment variabled defined
# in the .travis.yml in the top level folder of the project.

set -e

if [[ "$DISTRIB" == "conda" ]]; then
    # Deactivate the travis-provided virtual environment and setup a
    # conda-based environment instead
    deactivate

    # Use the miniconda installer for faster download / install of conda
    # itself
    DOWNLOAD_DIR=$HOME/download
    mkdir -p $DOWNLOAD_DIR
    wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh \
        -O $DOWNLOAD_DIR/miniconda.sh
    chmod +x $DOWNLOAD_DIR/miniconda.sh && \
        bash $DOWNLOAD_DIR/miniconda.sh -b -p $HOME/miniconda && \
        rm -r -f $DOWNLOAD_DIR
    export PATH=$HOME/miniconda/bin:$PATH
    conda update --yes conda

    # Configure the conda environment and put it in the path using the
    # provided versions
    conda create -n testenv --yes python=$PYTHON_VERSION pip numpy matplotlib scipy
    source activate testenv
fi

if [[ "$COVERAGE" == "true" ]]; then
    pip install coverage coveralls
fi
