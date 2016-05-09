# `CNVnator` packager

This repository contains code to help assist in compiling [`CNVnator`][1] and creating rudimentary debian packages.  Currently this downloads, compiles, and packages [`ROOT`][2] _(version 6.06.02)_, [`YEPPP`][3] _(version 1.0.0)_, [`samtools`][4] _(version 1.3)_, and [`CNVNator`][1] _(version 0.3.2)_ .

These instructions are based upon using a "default" untainted [Ubuntu cloud images for OpenStack][6], and with a user and group both named `ubuntu`.

## Pre-compiled binary packages

For already pre-compiled debian packages please see [cnvnator-packages][5].

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

    # check package existence
    ls -al /opt/cnvnator-0.3.2/*.deb
    
    # extract the CNVnator debian package to your host machine
    scp /opt/cnvnator-0.3.2/*.deb your-username@your-hostmachine:/path/to/download/directory

## NOTES

* The overall build directory can be changed by updating the `BASE_DIR` parameter in the `Makefile`.
* You'll need access to a `gcc` version 4.8 or higher to properly compile `ROOT`.

[1]: https://github.com/abyzovlab/CNVnator
[2]: https://root.cern.ch/
[3]: https://www.yeppp.info/
[4]: https://github.com/samtools/samtools
[5]: https://github.com/indraniel/cnvnator-packages
[6]: https://cloud-images.ubuntu.com
