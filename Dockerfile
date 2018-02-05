FROM ubuntu:16.04

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \ 
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y ca-certificates wget curl software-properties-common

RUN tee "/etc/apt/sources.list.d/kurento.list" > /dev/null \
	&& add-apt-repository "deb http://ubuntu.openvidu.io/6.7.0 xenial kms6" \
	&& add-apt-repository "deb http://ubuntu.openvidu.io/externals xenial kms6-externals" \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83 \
    && apt-get update \
    && apt-get install -y kurento-media-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
	
EXPOSE 8888

COPY ./entrypoint.sh /entrypoint.sh
COPY ./healthchecker.sh /healthchecker.sh

RUN chmod 777 /entrypoint.sh
RUN chmod 777 /healthchecker.sh

HEALTHCHECK --interval=5m --timeout=3s --retries=1 CMD /healthchecker.sh

ENV GST_DEBUG=Kurento*:5

ENTRYPOINT ["/entrypoint.sh"]