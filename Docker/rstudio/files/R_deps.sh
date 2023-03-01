#!/bin/bash
set -e

apt-get update && apt-get -y install locales lsb-release

## Configure default locale, see https://github.com/docker-library/docs/tree/master/ubuntu#locales
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
LANG=${LANG:-en_US.UTF-8}

UBUNTU_VERSION=${UBUNTU_VERSION:-$(lsb_release -sc)}

export DEBIAN_FRONTEND=noninteractive

READLINE_VERSION=8
OPENBLAS=libopenblas-dev
if [ ${UBUNTU_VERSION} == "bionic" ]; then
  READLINE_VERSION=7
  OPENBLAS=libopenblas-dev
fi

apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    devscripts \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-* \
    libcurl4 \
    libicu* \
    libpcre2* \
    libjpeg-turbo* \
    ${OPENBLAS} \
    libpangocairo-* \
    libpng16* \
    libreadline${READLINE_VERSION} \
    libtiff* \
    liblzma* \
    make \
    unzip \
    zip \
    zlib1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

BUILDDEPS="curl \
    default-jdk \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpcre2-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    perl \
    rsync \
    subversion \
    tcl-dev \
    tk-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    texlive-latex-extra \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    wget \
    zlib1g-dev"

apt-get install -y --no-install-recommends $BUILDDEPS && \
apt-get clean && rm -rf /var/lib/apt/lists/*
