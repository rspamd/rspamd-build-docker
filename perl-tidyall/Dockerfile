# Docker image for running tidyall:
# https://metacpan.org/release/Code-TidyAll

ARG  ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

# * perl-io-socket-ssl used by cpanm for https:// suport
# * install XS dependencies from binary packages and all other using cpanm
# * we don't verify perl modules signatures (most modules don't have them
#   anyway) so at least use https mirror: https://cpan.metacpan.org/

RUN set -x; \
	apk add --no-cache \
		perl-app-cpanminus perl-io-socket-ssl make \
		perl-clone perl-perlio-utf8_strict && \
	cpanm --quiet --no-wget --notest --no-man-pages --from https://cpan.metacpan.org/ \
		Code::TidyAll Code::TidyAll::Plugin::Test::Vars Perl::Critic Perl::Tidy Pod::Tidy && \
	rm -r /root/.cpanm

USER nobody
