# Ubuntu with build dependencies for rspamd

# 1. gcc is required for installing luacov-coveralls from luarocks
# 2. gcc provides gcov used by coveralls
FROM rspamd/ci-ubuntu-gcc:18.04

ARG run_deps="libunwind8 libluajit-5.1-2 libglib2.0-0 libevent-2.1 libicu60 libmagic1 libssl1.1 libsqlite3-0"
ARG coveralls_deps="python3-pip python3-setuptools python3-urllib3 python3-requests python3-future python3-openssl python3-certifi"
ARG test_deps="luarocks $coveralls_deps"

ENV DEBIAN_FRONTEND noninteractive

RUN set -x; \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $run_deps $test_deps && \
	luarocks install luacov && \
	luarocks install luacov-coveralls && \
	pip3 install --no-binary :all: cpp-coveralls && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists
