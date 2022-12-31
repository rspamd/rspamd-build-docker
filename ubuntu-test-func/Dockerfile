# Ubuntu with all dependencies for running rspamd functional tests

FROM rspamd/ci-ubuntu-test

ARG test_deps="$coveralls_deps clickhouse-server redis-server opendkim-tools miltertest"
ARG robot_test_deps="python3 python3-pip python3-setuptools python3-demjson python3-psutil python3-requests"

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
	pip3 install --no-cache --disable-pip-version-check --no-binary :all: robotframework tornado && \
	luarocks install luacheck && \
	apt-get -qy remove gpg gpg-agent && \
	apt-get -qy autoremove && \
	apt-get -q clean && \
	rm -rf /var/cache/debconf /var/lib/apt/lists
