# Fedora with runtime dependencies for rspamd
ARG  FEDORA_VERSION=29
FROM fedora:${FEDORA_VERSION}

# rspamd runtime dependencies:
#   file-libs
#   glib2
#   libevent
#   libicu
#   luajit
#   openssl-libs
#   pcre
#   sqlite-libs

# tools;
#   dnf-utils
#   gdb
#   llvm - for llvm-symbolizer

RUN set -x; \
	yum -qy --setopt install_weak_deps=False upgrade-minimal && \
	yum  -y --setopt install_weak_deps=False install \
		dnf-utils gdb llvm \
		file-libs glib2 libevent libicu luajit openssl-libs pcre sqlite-libs && \
	yum -qy --setopt install_weak_deps=False debuginfo-install \
		glibc glib2 luajit && \
	yum -qy remove dnf-utils && \
	rm /var/log/*.log && rm -r /var/cache/dnf

USER nobody
