FROM ubuntu:16.04

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \ 
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y bzip2 ca-certificates wget curl software-properties-common

RUN add-apt-repository "deb http://ubuntu.openvidu.io/6.7.0 xenial kms6" \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83 \
    && apt-get update \
    && apt-get install -y kurento-media-server openh264-gst-plugins-bad-1.5 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 8888

COPY ./entrypoint.sh /entrypoint.sh
COPY ./healthchecker.sh /healthchecker.sh

RUN chmod 777 /entrypoint.sh
RUN chmod 777 /healthchecker.sh

HEALTHCHECK --interval=5m --timeout=3s --retries=1 CMD /healthchecker.sh

ENV GST_DEBUG=3,Kurento*:5,kms*:5,webrtcendpoint:4,KurentoRecorderEndpointImpl:4,recorderendpoint:5,qtmux:4,rtspsrc*:5,playerendpoint:5,appsrc:7,agnosticbin*:7,kmselement:7,*CAPS*:1

ENTRYPOINT ["/entrypoint.sh"]