# `CNVnator` packager

This repository contains code to help assist in compiling [`CNVnator`][1] and creating rudimentary debian packages.  Currently this downloads, compiles, and packages [`ROOT`][2] _(version 6.06.02)_, [`YEPPP`][3] _(version 1.0.0)_, [`samtools`][4] _(version 1.3)_, and [`CNVNator`][1] _(version 0.3.2)_ .

These instructions are based on using [Docker][6] and a base [ubuntu:14.04][7] docker image.

## Pre-compiled binary packages

For already pre-compiled debian packages please see [cnvnator-packages][5].

## Usage

## Basic Package Creation Process

    git clone https://github.com/indraniel/cnvnator-packager
    cd cnvnator-packager
    docker build -t cnvnator:v1 .
    docker run -i -t $PWD:/release --rm cnvnator:v1

Afterwards, you should be able to see a `cnvnator_0.3.3-1ubuntu14.04.deb` debian package inside the root git `cnvnator-packager` repository directory.

### Post-Package Creation Testing

    cd cnvnator-packager # the root git repository directory
    docker run -i -t $PWD:/release --rm cnvnator:v1 bash

    # inside the docker container bash shell
    cd /release
    # manually install the prerequisites for the package
    apt-get update
    apt-get install build-essential libc6 zlib1g libgomp1 libstdc++6 libgcc1
    dpkg --install cnvnator_0.3.3-1ubuntu14.04.deb
    # the user wrapper should be at: /usr/local/bin/cnvnator
    cnvnator # should show the help message

## NOTES

* The overall build directory can be changed by updating the `BASE_DIR` parameter in the `Makefile`.
* You'll need access to a `gcc` version 4.8 or higher to properly compile `ROOT`.

[1]: https://github.com/abyzovlab/CNVnator
[2]: https://root.cern.ch/
[3]: https://www.yeppp.info/
[4]: https://github.com/samtools/samtools
[5]: https://github.com/indraniel/cnvnator-packages
[6]: https://www.docker.com/
[7]: https://hub.docker.com/_/ubuntu/
