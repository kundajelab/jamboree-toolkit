ARG PARENT_DOCKER

ARG NB_USER="jovyan"
ARG NB_UID=1000
ARG NB_GID=100

FROM "$PARENT_DOCKER"

ENV DEBIAN_FRONTEND noninteractive

USER root
RUN chmod -R 777 /opt && mkdir /data && chmod 775 /data
RUN APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
    ca-certificates \
    fonts-liberation \
    locales \
    pandoc \
    run-one \
    sudo \
    tini \
    wget \
    libbz2-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    liblzma-dev \
    gcc \
    build-essential \
    git \
    nano-tiny \
    tzdata \
    unzip \
    vim-tiny \
    openssh-client \
    inkscape \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    apt-utils \
    gfortran \
    software-properties-common \
    apt-transport-https \
    curl \
    gnupg \
    python3-pip && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install --yes google-cloud-sdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV HOME /home/$NB_USER

RUN echo 'root:neurogen'|chpasswd && \
    echo 'jovyan:neurogen'|chpasswd && \
    sed -i.bak -e 's/#%admin/%admin/' /etc/sudoers && \
    sed -i.bak -e 's/#%sudo/%sudo/' /etc/sudoers && \
    usermod -aG sudo jovyan && \
    chmod 0440 /etc/sudoers && \
    chmod -R 755 /home/$NB_USER

#course management 
USER $NB_UID
#RUN pip install jupyterhub-ltiauthenticator jupyter-packaging
#RUN git clone https://github.com/manics/nbgitpuller.git && cd nbgitpuller && git checkout jupyter-server && python setup.py build && python setup.py install 
RUN pip install nbgitpuller && \
    cp /opt/conda/lib/python3.9/site-packages/nbgitpuller/templates/status.html /opt/conda/lib/python3.9/site-packages/notebook/templates/status.html && \
    pip install ipywidgets && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    jupyter serverextension enable nbgitpuller --sys-prefix && \
    jupyter lab build --dev-build=False

USER root
RUN npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $NB_UID
