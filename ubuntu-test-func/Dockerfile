# Ubuntu with all dependencies for running rspamd functional tests

FROM rspamd/ci:ubuntu-test

ARG test_deps="$coveralls_deps clickhouse-server redis-server opendkim-tools miltertest libhyperscan5"
ARG robot_test_deps="python3 python3-pip python3-setuptools python3-demjson python3-psutil python3-requests"

USER root

RUN set -x; \
	apt-get -qq update && \
	apt-get -qy --no-install-recommends install wget ca-certificates gpg gpg-agent && \
  apt-get -qy --no-install-recommends install apt-transport-https ca-certificates dirmngr && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8919F6BD2B48D754 && \
  echo "deb https://packages.clickhouse.com/deb stable main" | tee /etc/apt/sources.list.d/clickhouse.list && \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $test_deps $robot_test_deps && \
	pip3 install --no-cache --disable-pip-version-check --no-binary :all: robotframework tornado && \
	luarocks install luacheck && \
	apt-get -qy remove gpg gpg-agent && \
	apt-get -qy autoremove && \
	apt-get -q clean && \
  mkdir -p /var/lib/rspamd && \
	rm -rf /var/cache/debconf /var/lib/apt/lists
