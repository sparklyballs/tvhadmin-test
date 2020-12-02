FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.12

# install tvhadmin
RUN \
	set -ex \
	&& git clone https://github.com/dave-p/TVHadmin /srv/tvhadmin

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /srv/tvhadmin/data
