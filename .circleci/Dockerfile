# How to build this image:
#
# sudo docker build --tag urbas/cam-thesis:x.y.z - < Dockerfile
# sudo docker push urbas/cam-thesis:x.y.z

FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    make \
    rsync \
    texlive \
    texlive-latex-extra

RUN rm -rf /usr/src/python ~/.cache
RUN rm -rf /var/lib/apt/lists/*

LABEL name="cam-thesis-ubuntu-16.04"

CMD ["/bin/bash"]