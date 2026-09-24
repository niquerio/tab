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
RUN cp README tab.1 && gzip tab.1

################################################################################
# RUNTIME
################################################################################
FROM base AS runtime

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  ghostscript \ 
  man \ 
  less

RUN mkdir /opt/tab_fonts && chown ${UID}:${GID} /opt/tab_fonts
COPY --chown=${UID}:{GID} --from=build /opt/Lute-Tab/*.tfm /opt/tab_fonts
COPY --chown=${UID}:{GID} --from=build /opt/Lute-Tab/*pk /opt/tab_fonts
ENV TABFONTS="/opt/tab_fonts"
RUN mkdir /opt/tab_docs && chown ${UID}:${GID} /opt/tab_docs
COPY --chown=${UID}:{GID} --from=build /opt/Lute-Tab/README /opt/tab_docs/README
COPY --chown=${UID}:{GID} --from=build /opt/Lute-Tab/AboutTab.txt /opt/tab_docs/AboutTab.txt

COPY --from=build /opt/Lute-Tab/tab.1.gz /usr/local/man/man1/tab.1.gz
COPY --from=build /opt/Lute-Tab/tab /usr/local/bin/tab

USER app
WORKDIR /app
