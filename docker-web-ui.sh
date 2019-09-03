#!/bin/bash
docker run -d --restart=always -p 8081:8080 --name regsitry-web \
--link <docker-registry-name> \
-e REGISTRY_URL=http://10.0.0.19:5000/v2 \
-e REGISTRY_NAME=localhost:5000 \
hyper/docker-registry-web

## docker-registry-name不要定义为registry,与web-ui容器内变量冲突
## 一定link上，因为要使用一个REGISTRY_NAME=localhost:5000
## https://hub.docker.com/r/hyper/docker-registry-web/

#docker run -d -p 5000:5000 --name registry-srv registry:2
#docker run -it -p 8080:8080 --name registry-web --link registry-srv \
#           -e REGISTRY_URL=https://registry-srv:5000/v2 \
#           -e REGISTRY_TRUST_ANY_SSL=true \
#           -e REGISTRY_BASIC_AUTH="YWRtaW46Y2hhbmdlbWU=" \
#           -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web

# conf/registry-web.yml
registry:
  # Docker registry url
  url: http://registry-srv:5000/v2
  # Docker registry fqdn
  name: localhost:5000
  # To allow image delete, should be false
  readonly: false
  auth:
    # Enable authentication
    enabled: true
    # Token issuer
    # should equals to auth.token.issuer of docker registry
    issuer: 'my issuer'
    # Private key for token signing
    # certificate used on auth.token.rootcertbundle should signed by this key
    key: /conf/auth.key
