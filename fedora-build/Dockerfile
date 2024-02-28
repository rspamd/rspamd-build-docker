# Fedora with clang and build dependencies for rspamd
ARG  FEDORA_VERSION=38

FROM fedora:${FEDORA_VERSION}

ARG c_compiler=clang
ARG cxx_compiler=clang++
ENV c_compiler=$c_compiler
ENV cxx_compiler=$cxx_compiler

# clang-plugin build dependencies:
#  * clang-devel
#  * llvm-devel
RUN set -x; \
	yum -qy --setopt install_weak_deps=False upgrade-minimal && \
	yum  -y --setopt install_weak_deps=False install clang compiler-rt lld cmake make pkgconf-pkg-config \
		perl ragel file-devel glib2-devel libarchive-devel libevent-devel libicu-devel luajit-devel openssl-devel sqlite-devel zlib-devel \
		clang-devel llvm-devel libsodium-devel ninja-build && \
	rm /var/log/*.log && rm -r /var/cache/dnf

RUN set -x; \
	sysArch="$(uname -m)" && \
	case "$sysArch" in \
		x86_64) \
			yum  -y --setopt install_weak_deps=False install hyperscan-devel && mkdir /vectorscan ; \
			;; \
		aarch64) \
			rm -fr /vectorscan-src/ /vectorscan && \
			yum  -y --setopt install_weak_deps=False install boost-devel git python3-devel && \
			git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.9 /vectorscan-src && \
			(cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_CXX_COMPILER="$cxx_compiler" -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) && \
			rm -fr /vectorscan-src/ ; \
			;; \
		*) \
			;; \
	esac

USER nobody
