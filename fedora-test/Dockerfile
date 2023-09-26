# Fedora with runtime dependencies for rspamd
ARG  FEDORA_BUILD_IMAGE=rspamd/ci:fedora-build
ARG  FEDORA_VERSION=29

FROM $FEDORA_BUILD_IMAGE as fedora-build-image
ARG  FEDORA_VERSION
FROM fedora:${FEDORA_VERSION}
# Copy vectorscan from build image on arm64
# /dump should be mounted as a volume to avoid polluting the image
COPY --from=fedora-build-image /vectorscan /dump/vectorscan

# rspamd runtime dependencies:
#   file-libs
#   glib2
#   libevent
#   libicu
#   luajit
#   openssl-libs
#   pcre
#   sqlite-libs
#   hyperscan

# tools;
#   dnf-plugins-core - for yum debuginfo-install
#   gdb
#   llvm - for llvm-symbolizer

RUN set -x; \
	sysArch="$(uname -m)" && \
	case "$sysArch" in \
		x86_64) \
			yum  -y --setopt install_weak_deps=False install hyperscan ; \
			;; \
                aarch64) \
			yum  -y --setopt install_weak_deps=False install libatomic ; \
			cp -R /dump/* / ; \
			;; \
		*) \
			;; \
	esac

RUN set -x; \
	yum -qy --setopt install_weak_deps=False upgrade-minimal && \
	yum  -y --setopt install_weak_deps=False install \
		dnf-plugins-core gdb llvm \
		file-libs glib2 libevent libicu libsodium luajit openssl-libs pcre sqlite-libs && \
	yum -qy --setopt install_weak_deps=False debuginfo-install \
		glibc glib2 libsodium luajit && \
	yum -qy remove dnf-plugins-core && \
	rm /var/log/*.log && rm -r /var/cache/dnf

USER nobody
