# Ubuntu with runtime dependencies for rspamd
# and tools/dependencies to run test/rspamd-test

# 1. gcc is required for installing luacov-coveralls from luarocks
# 2. gcc provides gcov used by coveralls
FROM rspamd/ci-ubuntu-gcc:18.04

# rspamd runtime dependencies (and also debug symbols to get more useful backtraces)
ARG run_deps=" libevent-2.1 libglib2.0-0 libglib2.0-0-dbgsym libicu60 libluajit-5.1-2 libmagic1 libsqlite3-0 libssl1.1 libunwind8"
# cpp-coveralls is not packaged and we have to install it using pip
# but most it dependencies can be installed from packages
ARG coveralls_deps="python3-pip python3-setuptools python3-urllib3 python3-requests python3-future python3-openssl python3-certifi"
# other test dependencies
ARG test_deps="luarocks gdb"

# cpp-coveralls depends on git, but with our layout -  build root / object
# files outside git repo directory it will not find git repo anyway.
# Create symlink as a hack to disable searching for git repo

RUN set -x; \
	apt-get -q update && \
	apt-get -qy install ubuntu-dbgsym-keyring && \
	. /etc/os-release && \
	printf "deb http://ddebs.ubuntu.com ${VERSION_CODENAME} main\ndeb http://ddebs.ubuntu.com ${VERSION_CODENAME}-updates main\n" > /etc/apt/sources.list.d/ddebs.list && \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $run_deps $coveralls_deps $test_deps && \
	luarocks install luacov && \
	luarocks install luacov-coveralls && \
	pip3 install --no-binary :all: cpp-coveralls && \
	ln -s /bin/true /usr/local/bin/git && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists

USER nobody
