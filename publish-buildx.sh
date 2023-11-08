#!/bin/bash
source .env

echo "cAdvisor version: $CADVISOR_VERSION"
echo "Building for following platforms: $PLATFORM"

docker buildx build . \
        --no-cache --push \
        --platform $PLATFORM \
        --build-arg CADVISOR_VERSION=$CADVISOR_VERSION \
        -t hougaard/advisor:$CADVISOR_VERSION \
        -t hougaard/advisor:latest