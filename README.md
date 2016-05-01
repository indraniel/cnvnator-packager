# `CNVnator` packager

This repository contains code to help assist in compiling [`CNVnator`][1] and creating rudimentary debian packages.  Currently this downloads, compiles, and packages [`ROOT`][2] _(version 6.06.02)_, [`YEPPP`][3] _(version 1.0.0)_, [`samtools`][4] _(version 1.3)_.

## Usage

### Ubuntu based distributions

    # setup the distribution
    sudo apt-get update
    sudo apt-get install build-essential
    sudo apt-get install git

    git clone https://github.com/indraniel/cnvnator-packager
    cd cnvnator-packager
    # download, and compile the sources 
    make
    # package up the relevant libraries, headers, files and executables
    make debian
    
    # look up the package
    cd $HOME/automation

    # install the package
    sudo dpkg -i $HOME/automation/cnvnator_0.3.2-1ubuntuX.Y.deb

    # run CNVnator
    /usr/local/bin/cnvnator

    # run ROOT
    /usr/local/bin/root

## NOTES

The overall build directory can be changed by updating the `BASE_DIR` parameter in the `Makefile`.

[1]: https://github.com/abyzovlab/CNVnator
[2]: https://root.cern.ch/
[3]: https://www.yeppp.info/
[4]: https://github.com/samtools/samtools
