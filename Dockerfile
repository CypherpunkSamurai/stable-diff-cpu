FROM continuumio/miniconda3:latest

LABEL maintainer="CypherpunkSamurai@users.noreply.github.com"

RUN apt-get update -yq
RUN apt-get install lib32stdc++6 -yq

ADD . /sdco
WORKDIR /sdco

# Install
RUN chmod 755 *.sh
RUN ./install_sdco.sh

RUN ["./run_sdco.sh"]