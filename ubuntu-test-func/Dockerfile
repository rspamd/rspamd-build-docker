# Ubuntu with all dependencies for running rspamd functional tests

FROM rspamd/ci-ubuntu-test

ARG test_deps="$coveralls_deps clickhouse-server redis-server opendkim-tools"
ARG robot_test_deps="python2.7 python-pip python-setuptools python-demjson python-psutil python-requests"

USER root

RUN set -x; \
	apt-get -qq update && \
	apt-get -qy --no-install-recommends install wget ca-certificates gpg gpg-agent && \
	wget https://repo.yandex.ru/clickhouse/CLICKHOUSE-KEY.GPG && \
	apt-key add --batch CLICKHOUSE-KEY.GPG && \
	rm CLICKHOUSE-KEY.GPG && \
	echo "deb http://repo.yandex.ru/clickhouse/deb/stable/ main/" > /etc/apt/sources.list.d/clickhouse.list && \
	apt-get -q update && \
	apt-get -qy --no-install-recommends install $test_deps $robot_test_deps && \
	pip install --no-cache --disable-pip-version-check --no-binary :all: robotframework && \
	luarocks install luacheck && \
	apt-get -qy remove gpg gpg-agent && \
	apt-get -qy autoremove && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists
