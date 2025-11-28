FROM almalinux:10

RUN set -x; \
  dnf -y install "dnf-command(config-manager)" && \
  dnf config-manager --set-enabled crb && \
  dnf -qy install epel-release && \
  dnf -qy --setopt install_weak_deps=False upgrade-minimal && \
  dnf  -y --setopt install_weak_deps=False install git clang compiler-rt gcc gcc-c++ lld cmake make pkgconf-pkg-config wget \
  	libarchive-devel perl file-devel glib2-devel libicu-devel openssl-devel sqlite-devel zlib-devel \
  	clang-devel llvm-devel libsodium-devel rpm-build openblas-devel libunwind-devel lapack lapack-devel blas-devel blas pcre2-devel sudo binutils systemd patch \
        gcc-c++ binutils systemd binutils-devel gcc-plugin-annobin libasan \
        python3-devel && \
  wget https://www.colm.net/files/ragel/ragel-6.10.tar.gz && rm -fr ragel-6.10 && \
  tar xvf ragel-6.10.tar.gz && (cd ragel-6.10 && ./configure --prefix=/usr && make -j4 && make install) && \
  rm -fr ragel-6.10 ; \
  rm -fr /luajit-src || true && \
	rm -fr /luajit-build || true && \
	git clone -b v2.1 https://luajit.org/git/luajit-2.0.git /luajit-src && \
	pushd /luajit-src && make clean && make -j4 CC="gcc -fPIC" PREFIX=/luajit-build && make install PREFIX=/luajit-build && popd && \
	rm -f /luajit-build/lib/*.so || true && \
	rm -fr /luajit-src || true && \
  rpmArch="$(rpm --eval '%{_arch}')" && \
  case "$rpmArch" in \
    *) \
       rm -fr /vectorscan-src/ ; \
       dnf -qy install python3-devel boost-devel && \
       git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.12 /vectorscan-src && \
       (cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) ; \
       rm -fr /vectorscan-src/ ; \
      ;; \
  esac && \
  rm /var/log/*.log && rm -r /var/cache/dnf 

# Install fasttext
RUN    ( rm -fr /fasttext-src/ || true ) && git clone https://github.com/rspamd/fastText.git --depth 1 /fasttext-src && \
       ( cd /fasttext-src && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/fasttext -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" && make -j4 && make install) && \
       mv -f /fasttext/lib/libfasttext_pic.a /fasttext/lib/libfasttext.a && \
       ( rm -f /fasttext/lib/*.so || true )  && \
       ( rm -fr /fasttext-src/ || true )
