## Build base image
FROM debian:buster AS base

RUN apt-get update && apt-get install -y \
    build-essential \
    g++-multilib \
    cmake \
    git \
    file \
    bc \
    rsync \
    bison \
    flex \
    gettext \
    texinfo \
    wget \
    cpio \
    python \
    unzip \
    mercurial \
    subversion \
    libncurses5-dev \
    libc6-dev-i386 \
    bzr \
    squashfs-tools \
    u-boot-tools \
    vim \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --user-group --system --create-home --no-log-init buildroot

## Build buildroot
FROM base AS builder
ARG CONFIG

RUN mkdir /opt/buildroot && chown buildroot /opt/buildroot
WORKDIR /opt/buildroot

USER buildroot

COPY --chown=buildroot:buildroot . /opt/buildroot

RUN make od_${CONFIG}_defconfig BR2_EXTERNAL=board/opendingux
RUN make source
RUN CONFIG=${CONFIG} ./rebuild.sh
RUN tar xf output/${CONFIG}/images/opendingux-${CONFIG}-toolchain.*.tar.xz

## Copy assets to the final image
FROM base
ARG CONFIG

COPY --from=builder /opt/buildroot/${CONFIG}-toolchain /opt/${CONFIG}-toolchain

WORKDIR /opt/${CONFIG}-toolchain
ENV PATH ${PATH}:/opt/${CONFIG}-toolchain/bin

RUN ./relocate-sdk.sh

USER buildroot
