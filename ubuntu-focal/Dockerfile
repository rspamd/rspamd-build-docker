ARG  UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND noninteractive
ARG build_deps="cmake make pkg-config ragel libc6-dev libevent-dev libglib2.0-dev libicu-dev git rsync wget libmagic-dev libsqlite3-dev libssl-dev libunwind-dev libsodium-dev ninja-build fakeroot make ca-certificates less devscripts debhelper dpkg-dev libcurl4-openssl-dev build-essential libopenblas-dev git libpcre2-dev"
ARG pre_deps="equivs gnupg2 wget git ca-certificates apt-utils sudo patch"
ARG compiler_deps="gcc g++ make libunwind-dev"
ARG c_compiler="gcc"
ARG cxx_compiler="g++"
SHELL ["/bin/bash", "-c"]

RUN set -x; \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $pre_deps && \
	apt-get -qy upgrade && \
  echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-16 main" >> /etc/apt/sources.list && \
  echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-16 main" >> /etc/apt/sources.list && \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $compiler_deps && \
	apt-get -qy --no-install-recommends install $build_deps && \
	rm -fr /luajit-src || true && \
	rm -fr /luajit-build || true && \
	git clone -b v2.1 https://luajit.org/git/luajit-2.0.git /luajit-src && \
	pushd /luajit-src && make clean && make -j4 CC="$c_compiler -fPIC" PREFIX=/luajit-build && make install PREFIX=/luajit-build && popd && \
	rm -f /luajit-build/lib/*.so || true && \
	rm -fr /luajit-src || true && \
	dpkgArch="$(dpkg --print-architecture)" && \
	case "$dpkgArch" in \
		amd64) \
			apt-get -qy --no-install-recommends install libhyperscan-dev libjemalloc-dev ; \
			;; \
		arm64) \
			rm -fr /vectorscan-src/ /vectorscan ; \
            apt-get -qy install python3-dev libboost-dev && \
		        git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.8 /vectorscan-src && \
		        (cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_CXX_COMPILER="$cxx_compiler" -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) ; \
		        rm -fr /vectorscan-src/ ; \
		        ;; \
		*) \
			;; \
	esac && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists
