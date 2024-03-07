ARG  FEDORA_VERSION=39

FROM fedora:${FEDORA_VERSION}

ARG c_compiler=clang
ARG cxx_compiler=clang++
ENV c_compiler=$c_compiler
ENV cxx_compiler=$cxx_compiler

# clang-plugin build dependencies:
#  * clang-devel
#  * llvm-devel
RUN	dnf install -y clang compiler-rt lld cmake make pkgconf-pkg-config \
	perl ragel file-devel glib2-devel libarchive-devel libevent-devel libicu-devel luajit-devel openssl-devel sqlite-devel zlib-devel \
	clang-devel llvm-devel libsodium-devel ninja-build git && \
	rm /var/log/*.log && rm -r /var/cache/dnf

RUN	set -x; \
	sysArch="$(uname -m)" && \
	case "$sysArch" in \
		x86_64) \
			dnf install -y hyperscan-devel && mkdir /vectorscan ; \
			;; \
		aarch64) \
			rm -fr /vectorscan-src/ /vectorscan && \
			dnf install -y boost-devel git python3-devel sqlite-devel && \
			git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.11 /vectorscan-src && \
			(cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_CXX_COMPILER="$cxx_compiler" -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) && \
			rm -fr /vectorscan-src/ ; \
			;; \
		*) \
			;; \
	esac

RUN	set -x; \
	sysArch="$(uname -m)" && \
	case "$sysArch" in \
		aarch64) \
			dnf install -y libatomic ; \
			;; \
		*) \
			;; \
	esac

RUN	dnf install -y \
		gdb llvm \
		file-libs glib2 libevent libicu libsodium luajit openssl-libs pcre sqlite-libs && \
	dnf debuginfo-install -y \
		glibc glib2 libsodium luajit && \
	rm /var/log/*.log && rm -r /var/cache/dnf

RUN	dnf install -y \
	python3 python3-pip python3-setuptools python3-demjson python3-psutil python3-requests python3-tornado \
	opendkim redis gdb && \
	rm /var/log/*.log && rm -r /var/cache/dnf && \
	pip3 install --no-cache --disable-pip-version-check --no-binary :all: robotframework

RUN	useradd -G wheel -m build -p ''

USER	build
