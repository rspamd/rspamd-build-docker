# Ubuntu with build dependencies for rspamd

# LTS (Bionic Beaver)
FROM rspamd/ci-ubuntu-gcc:20.04

ARG build_deps="cmake make pkg-config ragel libc6-dev libevent-dev libglib2.0-dev libicu-dev libluajit-5.1-dev libmagic-dev libsqlite3-dev libssl-dev libunwind-dev libsodium-dev"

RUN set -x; \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $build_deps && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists

USER nobody
