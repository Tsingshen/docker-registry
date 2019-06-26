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
