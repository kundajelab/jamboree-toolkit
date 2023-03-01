ARG PARENT_DOCKER
FROM "$PARENT_DOCKER"
ARG NB_USER="jovyan"
ARG NB_UID=1000
ARG NB_GID=100

USER root

ENV R_VERSION=4.1.2
ENV TERM=xterm
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://packagemanager.rstudio.com/cran/__linux__/focal/latest
ENV TZ=Etc/UTC

COPY files/* /tmp/
RUN chmod +x /tmp/*.sh && \
    /tmp/R_deps.sh && \
    /tmp/install_R.sh && \
    add-apt-repository universe -y && apt-get update -y && apt-get install -y gdebi-core && \
    wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.2-382-amd64.deb && \
    gdebi -n rstudio-server-2021.09.2-382-amd64.deb && \
    rm -rf /tmp/* && \
    rm -rf /home/${NB_USER}/R-${R_VERSION} && \
    rm -rf /home/${NB_USER}/R-${R_VERSION}.tar.gz && \
    rm -rf /home/${NB_USER}/rstudio-server-2021.09.2-382-amd64.deb

USER $NB_UID

RUN mkdir /home/${NB_USER}/.R && \
    echo "MAKEFLAGS+=-j \`nproc\`" > /home/${NB_USER}/.R/Makevars && \
    echo "CXX14 = g++ -std=c++1y -Wno-unused-variable -Wno-unused-function -fPIC" >> /home/${NB_USER}/.R/Makevars && \
    pip install jupyter-rsession-proxy && fix-permissions "/home/${NB_USER}"

EXPOSE 8888 8787
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
