FROM ubuntu:20.04
MAINTAINER Strack

RUN apt-get -qq update && \
apt-get -qq update && \
apt-get install -yq curl wget libwww-perl libjson-perl ethtool libyaml-dev file && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Declare args
ARG ARKIME_VERSION=4.3.2-1_amd64
ARG UBUNTU_VERSION=20.04
ARG ES_HOST=elasticsearch
ARG ES_PORT=9200
ARG ARKIME_PASSWORD=PASSWORDCHANGEME
ARG AKIME_INTERFACE=enp1s0
ARG CAPTURE=off
ARG VIEWER=on
ARG CONT3XT=on
ARG WISE=on
#Initalize is used to reset the environment from scratch and rebuild a new ES Stack
ARG INITALIZEDB=false
#Wipe is the same as initalize except it keeps users intact
ARG WIPEDB=false

# Declare envs vars for each arg
ENV ES_HOST $ES_HOST
ENV ES_PORT $ES_PORT
ENV ARKIME_LOCALELASTICSEARCH no
ENV ARKIME_ELASTICSEARCH "http://"$ES_HOST":"$ES_PORT
ENV AKIME_INTERFACE $AKIME_INTERFACE
ENV ARKIME_PASSWORD $AKIME_PASSWORD
ENV ARKIMEDIR "/opt/arkime"
ENV CAPTURE $CAPTURE
ENV VIEWER $VIEWER
ENV CONT3XT $CONT3XT
ENV WISE $WISE
ENV INITALIZEDB $INITALIZEDB
ENV WIPEDB=$WIPEDB

RUN mkdir -p /data
RUN cd /data && curl -C - -O "https://s3.amazonaws.com/files.molo.ch/builds/ubuntu-"$UBUNTU_VERSION"/arkime_"$ARKIME_VERSION".deb"
RUN cd /data && dpkg -i "arkime_"$ARKIME_VERSION".deb"

# add scripts
ADD /arkime/scripts /data/
ADD /arkime/etc /opt/arkime/etc/
RUN chmod 755 /data/startarkime.sh
RUN chmod 755 /data/wipearkime.sh
#Update Path
ENV PATH="/data:/opt/arkime/bin:${PATH}"

EXPOSE 8005
WORKDIR /opt/arkime

ENTRYPOINT ["/data/startarkime.sh"]
  


