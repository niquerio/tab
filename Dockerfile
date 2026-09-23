################################################################################
# BASE
################################################################################
FROM debian:stable-slim AS base

ARG UID=1000
ARG GID=1000


RUN groupadd -g ${GID} -o app
RUN useradd -m -d /app -u ${UID} -g ${GID} -o -s /bin/bash app

RUN mkdir -p /opt && chown ${UID}:${GID} /opt

################################################################################
# BUILD
################################################################################
FROM base AS build

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  build-essential \
  ca-certificates \
  git


USER app
WORKDIR /opt
RUN git clone https://github.com/mandovinnie/Lute-Tab.git
WORKDIR /opt/Lute-Tab
RUN make

################################################################################
# RUNTIME
################################################################################
FROM base AS runtime

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  ghostscript

RUN mkdir /opt/tab_fonts && chown ${UID}:${GID} /opt/tab_fonts
COPY --chown=${UID}:{GID} --from=build /opt/Lute-Tab/*.tfm /opt/tab_fonts
COPY --chown=${UID}:{GID} --from=build /opt/Lute-Tab/*pk /opt/tab_fonts
ENV TABFONTS="/opt/tab_fonts"

COPY --from=build /opt/Lute-Tab/tab /usr/local/bin/tab

USER app
WORKDIR /app
