FROM ubuntu:16.04

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \ 
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y ca-certificates wget curl
  
RUN echo "deb http://ubuntu.kurento.org xenial kms6" | tee /etc/apt/sources.list.d/kurento.list \
    && wget -O - http://ubuntu.kurento.org/kurento.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y kurento-media-server-6.0 \
	&& apt-get dist-upgrade \
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