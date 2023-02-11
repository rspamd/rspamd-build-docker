ARG  UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND noninteractive
ARG build_deps="cmake make pkg-config ragel libc6-dev libevent-dev libglib2.0-dev libicu-dev git rsync wget libmagic-dev libsqlite3-dev libssl-dev libunwind-dev libsodium-dev ninja-build fakeroot make ca-certificates less devscripts debhelper dpkg-dev libcurl4-openssl-dev build-essential libopenblas-dev git"
SHELL ["/bin/bash", "-c"]

RUN set -x; \
	apt-get -q update && \
	apt-get -qy upgrade && \
	apt-get -qy --no-install-recommends install gcc g++ make && \
	apt-get -qy --no-install-recommends install $build_deps && \
	rm -fr /luajit-src || true && \
	rm -fr /luajit-build || true && \
	git clone -b v2.1 https://luajit.org/git/luajit-2.0.git /luajit-src && \
	pushd /luajit-src && make clean && make -j4 CC="gcc -fPIC" PREFIX=/luajit-build && make install PREFIX=/luajit-build && popd && \
	rm -f /luajit-build/lib/*.so || true && \
	rm -fr /luajit-src || true && \
	dpkgArch="$(dpkg --print-architecture)" && \
	case "$dpkgArch" in \
		amd64) \
			apt-get -qy --no-install-recommends install libhyperscan-dev libjemalloc-dev ; \
			;; \
		arm64) \
			rm -fr /vectorscan-src/ /vectorscan ; \
		        dnf -qy install python3-devel boost-devel git && \
		        git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.8 /vectorscan-src && \
		        (cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) ; \
		        rm -fr /vectorscan-src/ ; \
		        ;; \
		*) \
			;; \
	esac && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists
