# How to build this image:
#
# sudo docker build --tag urbas/cam-thesis-ubuntu:20.04-x - < Dockerfile
# sudo docker push urbas/cam-thesis-ubuntu:20.04-x

FROM buildpack-deps:20.04-scm

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    gzip \
    make \
    python \
    rsync \
    ssh \
    tar \
    texlive \
    texlive-latex-extra \
    && apt-get clean

RUN rm -rf ~/.cache /var/lib/apt/lists/*

LABEL name="cam-thesis-ubuntu-20.04"

CMD ["/bin/bash"]