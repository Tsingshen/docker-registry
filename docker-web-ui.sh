#!/bin/bash
docker run -d --restart=always -p 8081:8080 --name regsitry-web \
--link <docker-registry-name> \
-e REGISTRY_URL=http://10.0.0.19:5000/v2 \
-e REGISTRY_NAME=localhost:5000 \
hyper/docker-registry-web

## docker-registry-name不要定义为registry,与web-ui容器内变量冲突
## 一定link上，因为要使用一个REGISTRY_NAME=localhost:5000
## https://hub.docker.com/r/hyper/docker-registry-web/
