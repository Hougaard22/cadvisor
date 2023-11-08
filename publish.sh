#!/bin/bash
source .env

docker build . --platform linux/arm64 -t "cadvisor:arm64"
docker build . --platform linux/amd64 -t "cadvisor:amd64"

for arch in amd64 arm64; do
 docker tag "cadvisor:${arch}" "hougaard/cadvisor:${arch}"
 docker push "hougaard/cadvisor:${arch}"
done

docker manifest rm "hougaard/cadvisor:latest"
docker manifest create "hougaard/cadvisor:latest" \
    "hougaard/cadvisor:amd64" \
    "hougaard/cadvisor:arm64"
# Annotate manifest
docker manifest annotate --arch arm64 --os linux "hougaard/cadvisor:latest" "hougaard/cadvisor:arm64"
docker manifest annotate --arch amd64 --os linux "hougaard/cadvisor:latest" "hougaard/cadvisor:amd64"
#docker manifest inspect "hougaard/cadvisor:latest"
docker manifest push "hougaard/cadvisor:latest"

docker manifest rm "hougaard/cadvisor:${CADVISOR_VERSION}"
docker manifest create "hougaard/cadvisor:${CADVISOR_VERSION}" \
    "hougaard/cadvisor:amd64"  \
    "hougaard/cadvisor:arm64"
# Annotate manifest
docker manifest annotate --arch arm64 --os linux "hougaard/cadvisor:${CADVISOR_VERSION}" "hougaard/cadvisor:arm64"
docker manifest annotate --arch amd64 --os linux "hougaard/cadvisor:${CADVISOR_VERSION}" "hougaard/cadvisor:amd64"
#docker manifest inspect "hougaard/cadvisor:${CADVISOR_VERSION}"
docker manifest push "hougaard/cadvisor:${CADVISOR_VERSION}"