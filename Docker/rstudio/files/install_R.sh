#!/bin/bash
set -e

## Configure default locale, see https://github.com/docker-library/docs/tree/master/ubuntu#locales
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
LANG=${LANG:-en_US.UTF-8}

UBUNTU_VERSION=${UBUNTU_VERSION:-$(lsb_release -sc)}
CRAN=${CRAN:-https://cran.r-project.org}

##  mechanism to force source installs if we're using RSPM
CRAN_SOURCE=${CRAN/"__linux__/$UBUNTU_VERSION/"/""}

export DEBIAN_FRONTEND=noninteractive
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

## Set up and install R
R_HOME=${R_HOME:-/usr/local/lib/R}

wget https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz && \
	tar xzf R-${R_VERSION}.tar.gz && \
	cd R-${R_VERSION}

R_PAPERSIZE=letter \
R_BATCHSAVE="--no-save --no-restore" \
R_BROWSER=xdg-open \
PAGER=/usr/bin/pager \
PERL=/usr/bin/perl \
R_UNZIPCMD=/usr/bin/unzip \
R_ZIPCMD=/usr/bin/zip \
R_PRINTCMD=/usr/bin/lpr \
LIBnn=lib \
AWK=/usr/bin/awk \
CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
./configure --enable-R-shlib \
		   --enable-memory-profiling \
		   --with-readline \
		   --with-blas \
		   --with-lapack \
		   --with-tcltk \
		   --with-recommended-packages && \
	make && \
	make install && \
	make clean

## Add a default CRAN mirror
echo "options(repos = c(CRAN = '${CRAN}'), download.file.method = 'libcurl')" >> ${R_HOME}/etc/Rprofile.site

## Set HTTPUserAgent for RSPM (https://github.com/rocker-org/rocker/issues/400)
echo  'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(),
                 paste(getRversion(), R.version$platform,
                       R.version$arch, R.version$os)))' >> ${R_HOME}/etc/Rprofile.site

## Add a library directory (for user-installed packages)
mkdir -p ${R_HOME}/site-library && \
	chown root:staff ${R_HOME}/site-library && \
	chmod g+ws ${R_HOME}/site-library

## Fix library path
echo "R_LIBS=\${R_LIBS-'${R_HOME}/site-library:${R_HOME}/library'}" >> ${R_HOME}/etc/Renviron.site

## Use littler installation scripts
Rscript -e "install.packages(c('littler', 'docopt'), repos='${CRAN_SOURCE}')" && \
	ln -s ${R_HOME}/site-library/littler/examples/install2.r /usr/local/bin/install2.r && \
	ln -s ${R_HOME}/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
	ln -s ${R_HOME}/site-library/littler/bin/r /usr/local/bin/r && \
	chmod -R 777 ${R_HOME}

## Clean up from R source install
cd .. && \
	rm -rf R-${R_VERSION}.tar.gz && \
	rm -rf R-${R_VERSION} && \
	apt-get autoremove -y && \
	apt-get autoclean -y && \
	rm -rf /var/lib/apt/lists/*