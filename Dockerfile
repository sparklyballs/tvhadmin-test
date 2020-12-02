ARG ALPINE_VER="3.12"
FROM alpine:${ALPINE_VER} as fetch-stage

############## fetch stage ##############

# install fetch packages
RUN \
	apk add --no-cache \
		bash \
		curl \
		xz

# set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# fetch version file
RUN \
	set -ex \
	&& curl -o \
	/tmp/version.txt -L \
		"https://raw.githubusercontent.com/sparklyballs/versioning/master/version.txt"

# fetch source code
# hadolint ignore=SC1091
RUN \
	. /tmp/version.txt \
	&& set -ex \
	&& mkdir -p \ 
		/srv/tvhadmin \
	&& curl -o \
	/tmp/tvhadmin.tar.gz -L \
		"https://github.com/dave-p/TVHadmin/archive/${TVHADMIN_COMMIT}.tar.gz" \
	&& tar xf \
	/tmp/tvhadmin.tar.gz -C \
		/srv/tvhadmin --strip-components=1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:${ALPINE_VER}

############## runtine stage ##############

# copy artifacts from fetch stage
COPY --from=fetch-stage /srv/tvhadmin /srv/tvhadmin

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /srv/tvhadmin/data
