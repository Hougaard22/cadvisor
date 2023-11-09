#!/bin/bash
source .env

docker build . --platform linux/arm64 -t "cadvisor:arm64"
docker build . --platform linux/amd64 -t "cadvisor:amd64"
docker build . --platform linux/arm/v7 -t "cadvisor:armv7"
docker build . --platform linux/arm/v6 -t "cadvisor:armv6"

for ARCH in amd64 arm64 armv6 armv7; do
 docker tag "cadvisor:${ARCH}" "hougaard/cadvisor:v0.48.1-${ARCH}"
 docker push "hougaard/cadvisor:v0.48.1-${ARCH}"
done

for TAG in "$CADVISOR_VERSION" "lastest"; do
    docker manifest rm "hougaard/cadvisor:$TAG"
    docker manifest create "hougaard/cadvisor:$TAG" \
        "hougaard/cadvisor:$CADVISOR_VERSION-amd64" \
        "hougaard/cadvisor:$CADVISOR_VERSION-arm64" \
        "hougaard/cadvisor:$CADVISOR_VERSION-armv7" \
        "hougaard/cadvisor:$CADVISOR_VERSION-armv6"
    # Annotate manifest
    docker manifest annotate --arch arm64 --os linux "hougaard/cadvisor:latest" "hougaard/cadvisor:$CADVISOR_VERSION-arm64"
    docker manifest annotate --arch amd64 --os linux "hougaard/cadvisor:latest" "hougaard/cadvisor:$CADVISOR_VERSION-amd64"
    docker manifest annotate --arch arm --variant v7 --os linux "hougaard/cadvisor:latest" "hougaard/cadvisor:$CADVISOR_VERSION-armv7"
    docker manifest annotate --arch arm --variant v6 --os linux "hougaard/cadvisor:latest" "hougaard/cadvisor:$CADVISOR_VERSION-armv6"
    #docker manifest inspect "hougaard/cadvisor:latest"
    docker manifest push "hougaard/cadvisor:$TAG"
done