FROM oraclelinux:7-slim

# clang-plugin build dependencies:
#  * clang-devel
#  * llvm-devel
# Additional things:
# Ragel is broken, need to build ragel 6.10 from the sources
# Boost is too old, need a better boost, lol
RUN set -x; \
  printf "[ol7_software_collections]\nname=Software Collection Library release 3.0 packages for Oracle Linux 7 (\$basearch)\nbaseurl=https://yum.oracle.com/repo/OracleLinux/OL7/SoftwareCollections/\$basearch/\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle\ngpgcheck=1\nenabled=1\n" > /etc/yum.repos.d/sc.repo && \
  printf "[ol7_epel]\nname=Oracle Linux \$releasever EPEL (\$basearch)\nbaseurl=https://yum.oracle.com/repo/OracleLinux/OL7/developer_EPEL/\$basearch/\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle\ngpgcheck=1\nenabled=1\n" > /etc/yum.repos.d/epel.repo && \
  yum-config-manager --enable ol7_optional_latest ol7_addons && \
  yum -qy --setopt install_weak_deps=False upgrade-minimal && \
  yum  -y --setopt install_weak_deps=False install clang compiler-rt gcc gcc-c++ cmake3 make pkgconf-pkg-config \
  	perl ragel file-devel glib2-devel libicu-devel openssl-devel sqlite-devel zlib-devel \
  	clang-devel llvm-devel libsodium-devel git rpm-build openblas-devel libunwind-devel lapack lapack-devel blas-devel blas pcre2-devel devtoolset-10-llvm-devel devtoolset-10-clang-devel devtoolset-10-libasan-devel sudo patch && \
  yum -qy install devtoolset-10-gcc-c++  python3-devel boost-devel git cmake3 wget && \
  wget https://www.colm.net/files/ragel/ragel-6.10.tar.gz && rm -fr ragel-6.10 && \
  tar xvf ragel-6.10.tar.gz && (cd ragel-6.10 && ./configure --prefix=/usr && make -j4 && make install) && \
  rm -fr ragel-6.10 ; \
  wget https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz -O /boost.tar.gz && \
  tar -xf /boost.tar.gz && \
  rm -fr /vectorscan-src/ ; \
  rpmArch="$(rpm --eval '%{_arch}')" && \
  case "$rpmArch" in \
    aarch64) \
      git clone https://github.com/VectorCamp/vectorscan --depth 1 --branch vectorscan/5.4.8 /vectorscan-src  \
      ;; \
    *) \
      git clone https://github.com/intel/hyperscan/ --depth 1 --branch v5.4.1 /vectorscan-src  \
      ;; \
    esac && \
  (source /opt/rh/devtoolset-10/enable ; cd /vectorscan-src ; mkdir build ; cd build ; cmake3 .. -DCMAKE_INSTALL_PREFIX=/vectorscan -DCMAKE_BUILD_TYPE=Release -DFAT_RUNTIME=ON -DCMAKE_C_FLAGS="-fpic -fPIC" -DCMAKE_CXX_FLAGS="-fPIC -fpic" -DPCRE_SUPPORT_LIBBZ2=OFF -DBOOST_ROOT=/boost_1_76_0; make -j4 ; make install) && \
  rm -fr /vectorscan-src/ ; \
  rm -fr /boost.tar.gz ; \
  rm -fr /boost_1_76_0 ; \
  rpmArch="$(rpm --eval '%{_arch}')" && \
  case "$rpmArch" in \
    x86_64) \
       yum -qy install jemalloc-devel  \
      ;; \
    *) \
      ;; \
  esac && \
  yum -y clean all || true
