ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}

ARG build_deps="binutils-dev cmake gcc g++ libarchive-dev libc6-dev libevent-dev libfasttext-dev libglib2.0-dev libicu-dev libluajit-5.1-dev libmagic-dev libsqlite3-dev libssl-dev libunwind-dev libsodium-dev make ninja-build pkg-config ragel"
ARG ci_deps="git sudo"
ARG vectorscan_deps="cmake g++ git libboost-dev libsqlite3-dev pkg-config python3-dev ragel"
ARG test_deps="clickhouse-server gdb miltertest opendkim-tools python3-tornado redis-server"
ARG robot_test_deps="python3 python3-pip python3-setuptools python3-demjson python3-psutil python3-requests python3-Knacl"

ARG c_compiler=gcc
ARG cxx_compiler=g++

ENV DEBIAN_FRONTEND noninteractive

RUN     apt-get update && \
	dpkgArch="$(dpkg --print-architecture)" && \
	set -x && \
	case "$dpkgArch" in \
		amd64) \
			apt-get -qy --no-install-recommends install libhyperscan-dev libjemalloc-dev && mkdir /vectorscan ; \
			;; \
		arm64) \
			rm -fr /vectorscan-src/ /vectorscan && \
			apt-get -qy install $vectorscan_deps && \
			git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.11 /vectorscan-src && \
			(cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_CXX_COMPILER="$cxx_compiler" -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) && \
			rm -fr /vectorscan-src/ ; \
			;; \
		*) \
			;; \
	esac && \
	apt-get -qy --no-install-recommends install wget ca-certificates gpg gpg-agent && \
	apt-get -qy --no-install-recommends install apt-transport-https ca-certificates dirmngr && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8919F6BD2B48D754 && \
	echo "deb https://packages.clickhouse.com/deb stable main" | tee /etc/apt/sources.list.d/clickhouse.list && \
	apt-get update && \
	apt-get -qy --no-install-recommends install $build_deps $ci_deps $test_deps $robot_test_deps && \
	apt-get -q clean && \
	rm -rf /var/lib/apt/lists/* /var/log/apt/*.log && \
	pip3 install --no-cache --disable-pip-version-check --no-binary :all: robotframework && \
	useradd -G sudo -m build && \
	passwd -d build

USER build
