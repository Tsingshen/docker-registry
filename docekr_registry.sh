mkdir -p /root/docker-registry
cd /root/docker-registry
cat > docker-compose.yml <<- EOF
version: "3"
services:
  registry:
    image: registry:2
    ports:
      - 80:5000
    volumes:
      - /data/registry:/var/lib/registry
    restart: always
    environment:
      REGISTRY_STORAGE_DELETE_ENABLED: "true"
EOF
docker-compose up -d
