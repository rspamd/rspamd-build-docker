# Ubuntu with gcc
# Base layer for other iamges
ARG  UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN set -x; \
	apt-get -q update && \
	apt-get -qy upgrade && \
	apt-get -qy --no-install-recommends install gcc && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists
