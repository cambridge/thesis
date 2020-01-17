# How to build this image:
#
# sudo docker build --tag urbas/cam-thesis-ubuntu:18.04-x - < Dockerfile
# sudo docker push urbas/cam-thesis-ubuntu:18.04-x

FROM buildpack-deps:18.04-scm

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    gzip \
    make \
    python-pip \
    rsync \
    ssh \
    tar \
    texlive \
    texlive-latex-extra \
    && apt-get clean

RUN pip install --no-cache-dir --upgrade --force-reinstall \
  setuptools

RUN rm -rf /usr/src/python ~/.cache
RUN rm -rf /var/lib/apt/lists/*

LABEL name="cam-thesis-ubuntu-18.04"

CMD ["/bin/bash"]