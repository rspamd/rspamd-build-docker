# Ubuntu with build dependencies for rspamd

ARG  UBUNTU_GCC_IMAGE=rspamd/ci:ubuntu-gcc
FROM $UBUNTU_GCC_IMAGE

ARG build_deps="binutils-dev cmake make pkg-config ragel libc6-dev libevent-dev libglib2.0-dev libicu-dev libluajit-5.1-dev libmagic-dev libsqlite3-dev libssl-dev libunwind-dev libsodium-dev ninja-build"
ARG c_compiler=gcc
ARG cxx_compiler=g++

RUN set -x; \
	apt-get -q update && \
        dpkgArch="$(dpkg --print-architecture)" && \
        case "$dpkgArch" in \
                amd64) \
                        apt-get -qy --no-install-recommends install libhyperscan-dev libjemalloc-dev && mkdir /vectorscan ; \
                        ;; \
                arm64) \
                        rm -fr /vectorscan-src/ /vectorscan && \
                        apt-get -qy install python3-dev libboost-dev git cmake ragel && \
                        git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.9 /vectorscan-src && \
                        (cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_CXX_COMPILER="$cxx_compiler" -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) && \
                        rm -fr /vectorscan-src/ ; \
                        ;; \
                *) \
                        ;; \
        esac && \
	apt-get -qy --no-install-recommends install $build_deps && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists

USER nobody
