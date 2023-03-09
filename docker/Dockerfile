# Imported from https://hub.docker.com/r/sphinxdoc/sphinx/dockerfile
# maintainer="Sphinx Team <https://www.sphinx-doc.org/>"
# $ docker build --pull \
#   --tag ${REGISTRY}/sphinxdoc
#   --file Dockerfile .
FROM python:3.9-slim
LABEL maintainer="Pramod Ramarao <pramarao@nvidia>, Mike McKiernan <mmckiernan@nvidia.com>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && apt-get install --no-install-recommends -y \
      unzip \
      graphviz \
      imagemagick \
      make \
      curl \
      python3 python3-pip \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir -U pip
RUN python3 -m pip install --no-cache-dir "Sphinx<=4.6" Pillow
RUN python3 -m pip install --no-cache-dir sphinx-copybutton
RUN python3 -m pip install --no-cache-dir sphinx-tabs
RUN python3 -m pip install --no-cache-dir sphinxcontrib-blockdiag
RUN python3 -m pip install --no-cache-dir "sphinx_rtd_theme==1.0.0"

# Install fonts for blockdiag
#Download IBM Plex
#curl -fOSsL https://github.com/IBM/plex/raw/v5.1.3/IBM-Plex-Mono/fonts/complete/ttf/IBMPlexMono-Regular.ttf
#Download Roboto https://fonts.google.com/specimen/Roboto
COPY *.ttf /usr/share/fonts/truetype/
RUN fc-cache

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws*

RUN curl -L -o /usr/local/bin/akamai-purge \
  https://github.com/akamai/cli-purge/releases/download/1.0.1/akamai-purge-1.0.1-linuxamd64 \
  && chmod a+x /usr/local/bin/akamai-purge

CMD /bin/bash