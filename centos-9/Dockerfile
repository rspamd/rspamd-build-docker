FROM oraclelinux:9-slim

RUN set -x; \
  microdnf install dnf && \
  dnf -qy install epel-release && \
  dnf config-manager --set-enabled ol9_codeready_builder && \
  dnf -qy --setopt install_weak_deps=False upgrade-minimal && \
  dnf  -y --setopt install_weak_deps=False install clang compiler-rt gcc gcc-c++ lld cmake make pkgconf-pkg-config wget \
  	perl ragel file-devel glib2-devel libicu-devel openssl-devel sqlite-devel zlib-devel \
  	clang-devel llvm-devel libsodium-devel git rpm-build openblas-devel libunwind-devel lapack lapack-devel blas-devel blas pcre2-devel sudo binutils systemd patch \
    gcc-toolset-12-gcc-c++ binutils systemd gcc-toolset-12-binutils-devel gcc-toolset-12-libasan-devel gcc-toolset-12-gcc-plugin-annobin  && \
  wget https://www.colm.net/files/ragel/ragel-6.10.tar.gz && rm -fr ragel-6.10 && \
  #ln -sf /opt/rh/gcc-toolset-12/root/usr/lib/gcc/${rpmArch}-redhat-linux/12/plugin/annobin.so /opt/rh/gcc-toolset-12/root/usr/lib/gcc/${rpmArch}-redhat-linux/12/plugin/gcc-annobin.so && \
  tar xvf ragel-6.10.tar.gz && (cd ragel-6.10 && ./configure --prefix=/usr && make -j4 && make install) && \
  rm -fr ragel-6.10 ; \
  rpmArch="$(rpm --eval '%{_arch}')" && \
  case "$rpmArch" in \
    aarch64) \
       rm -fr /vectorscan-src/ ; \
       dnf -qy install python3-devel boost-devel git && \
       git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.9 /vectorscan-src && \
       (cd /vectorscan-src ; mkdir build ; cd build ; cmake .. -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF; make -j4 ; make install) ; \
       rm -fr /vectorscan-src/ ; \
      ;; \
    *) \
       dnf -qy install hyperscan-devel jemalloc-devel git python3-devel \
      ;; \
  esac && \
  rm /var/log/*.log && rm -r /var/cache/dnf 

# Install fasttext
RUN    rm -fr /fasttext-src/ ; git clone https://github.com/rspamd/fastText.git --depth 1 /fasttext-src && \
       (cd /fasttext-src ; mkdir build ; cd build ; cmake .. -DCMAKE_INSTALL_PREFIX=/fasttext -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic"; make -j4 ; make install) ; \
       mv -f /fasttext/lib/libfasttext_pic.a /fasttext/lib/libfasttext.a ; \
       rm -f /fasttext/lib/*.so ; \
       rm -fr /fasttext-src/
