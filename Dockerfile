FROM debian:stable-slim

ARG UID=1000
ARG GID=1000

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  build-essential \
  ca-certificates \
  ghostscript \
  git

RUN groupadd -g ${GID} -o app
RUN useradd -m -d /app -u ${UID} -g ${GID} -o -s /bin/bash app

RUN mkdir -p /opt && chown ${UID}:${GID} /opt
USER app
WORKDIR /opt

RUN git clone https://github.com/mandovinnie/Lute-Tab.git
ENV TABFONTS="/opt/Lute-Tab"
WORKDIR /opt/Lute-Tab
RUN make

USER root
RUN ln -s /opt/Lute-Tab/tab /usr/local/bin/tab

USER app
WORKDIR /app


