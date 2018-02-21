# kurento_docker
Docker for Kurento Media Server

docker build -t nas2docker/kurento_dev --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy .

docker run -d -v /var/log/:/var/log/ -p 8888:8888 nas2docker/kurento_dev

Environment variables: -e GST_DEBUG=Kurento*:5

cat /proc/sys/kernel/core_pattern --> to check crash log dump location
