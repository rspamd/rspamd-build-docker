# Fedora with clang and build dependencies for rspamd
ARG  FEDORA_VERSION=29
FROM fedora:${FEDORA_VERSION}

# clang-devel and llvm-devel are used to build clang-plugin
RUN set -x; \
	yum -qy --setopt install_weak_deps=False upgrade-minimal && \
	yum  -y --setopt install_weak_deps=False install clang lld cmake make pkgconf-pkg-config \
		perl ragel file-devel glib2-devel libevent-devel libicu-devel luajit-devel openssl-devel sqlite-devel \
		clang-devel llvm-devel && \
	rm /var/log/*.log && rm -r /var/cache/dnf

USER nobody
