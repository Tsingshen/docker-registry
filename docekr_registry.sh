mkdir -p /root/docker-registry
cd /root/docker-registry
cat > docker-compose.yml <<- EOF
version: "3"
services:
  registry:
    image: registry:2
    ports:
      - 8080:5000
    volumes:
      - /data/registry-registry:/var/lib/registry
    restart: always
    environment:
      REGISTRY_STORAGE_DELETE_ENABLED: "true"
EOF
docker-compose up -d


## mirror
cat > docker-compose.yml <<- EOF
version: "3"
services:
  mirror:
    image: registry:2
    ports:
      - 80:5000
    volumes:
      - /data/registry-mirror:/var/lib/registry
    restart: always
    environment:
      REGISTRY_PROXY_REMOTEURL: "https://labrtv3.mirror.aliyuncs.com"
EOF
docker-compose up -d


----------------------------------------------
## whit native basic auth
## Warning: You cannot use authentication with authentication schemes that send credentials as clear text. 
## You must configure TLS first for authentication to work.


Create a password file with one entry for the user testuser, with password testpassword:

$ mkdir auth
$ docker run \
  --entrypoint htpasswd \
  registry:2 -Bbn testuser testpassword > auth/htpasswd

Stop the registry.

$ docker container stop registry

Start the registry with basic authentication.

$ docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v "$(pwd)"/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2



Try to pull an image from the registry, or push an image to the registry. These commands fail.

Log in to the registry.

$ docker login myregistrydomain.com:5000

Provide the username and password from the first step.

Test that you can now pull an image from the registry or push an image to the registry.
## Use self-signed certificates https://docs.docker.com/registry/insecure/

#!/bin/bash
docker run --name registry2 -d \
-p 9200:5000 \
-v /root/htpasswd:/auth/htpasswd \
-v /data/registry-registry:/var/lib/registry \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
registry:2


---------
## https://docs.docker.com/registry/deploying/
registry:
  restart: always
  image: registry:2
  ports:
    - 5000:5000
  environment:
    REGISTRY_HTTP_TLS_CERTIFICATE: /certs/domain.crt
    REGISTRY_HTTP_TLS_KEY: /certs/domain.key
    REGISTRY_AUTH: htpasswd
    REGISTRY_AUTH_HTPASSWD_PATH: /auth/htpasswd
    REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
  volumes:
    - /path/data:/var/lib/registry
    - /path/certs:/certs
    - /path/auth:/auth


