FROM ubuntu:14.04
MAINTAINER Indraniel Das <idas@wustl.edu>

# Volumes
VOLUME /build
VOLUME /release

# bootstrap build dependencies
RUN apt-get update -qq && \
    apt-get -y install apt-transport-https && \
    echo "deb [trusted=yes] https://bitbucket.org/idas/ccdg-apt-repo/raw/master ccdg main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get -y install \
    build-essential \
    debhelper \
    automake \
    autotools-dev \
    git \
    curl \
    ca-certificates \
    ccdg-python-2.7.12 \
    --no-install-recommends

WORKDIR /build

ENV PATH=/opt/ccdg/python-2.7.12/bin:${PATH}

# Import resources
COPY ./Makefile /build

CMD make && make debian
