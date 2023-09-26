# Ubuntu with runtime dependencies for rspamd
# and tools/dependencies to run test/rspamd-test

ARG  UBUNTU_BUILD_IMAGE=rspamd/ci:ubuntu-build
ARG  UBUNTU_GCC_IMAGE=rspamd/ci:ubuntu-gcc

FROM $UBUNTU_BUILD_IMAGE as ubuntu-build-image

# 1. gcc is required for installing luacov-coveralls from luarocks
# 2. gcc provides gcov used by gcov_coveralls.py
ARG  UBUNTU_GCC_IMAGE
FROM $UBUNTU_GCC_IMAGE
# Copy vectorscan from build image on arm64
# /dump should be mounted as a volume to avoid polluting the image
COPY --from=ubuntu-build-image /vectorscan /dump/vectorscan

ARG c_compiler=gcc
ARG cxx_compiler=g++
# rspamd runtime dependencies (and also debug symbols to get more useful backtraces)
ARG run_deps="libevent-2.1 libglib2.0-0 libglib2.0-dev libicu70 libluajit-5.1-2 libmagic1 libsqlite3-0 libssl3 libunwind8 libsodium23"
# test dependencies:
# * luarocks used to install luacov and luacov-coveralls
# * python3-requests used by merge_coveralls.py
ARG test_deps="luarocks gdb python3 python3-requests"

RUN set -x; \
	apt-get -q update && \
	dpkgArch="$(dpkg --print-architecture)" && \
	case "$dpkgArch" in \
		amd64) \
			apt-get -qy --no-install-recommends install libhyperscan5 ; \
			;; \
		arm64) \
			cp -R /dump/* / ; \
			;; \
		*) \
			;; \
	esac && \
	apt-get -qy install ubuntu-dbgsym-keyring && \
	. /etc/os-release && \
	printf "deb http://ddebs.ubuntu.com ${VERSION_CODENAME} main\ndeb http://ddebs.ubuntu.com ${VERSION_CODENAME}-updates main\n" > /etc/apt/sources.list.d/ddebs.list && \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $run_deps $test_deps && \
	luarocks install luacov && \
	luarocks install luacov-coveralls && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists

USER nobody
