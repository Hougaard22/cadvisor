# Builder
FROM golang:latest as builder
ARG CADVISOR_VERSION="v0.48.1"

RUN git clone --branch ${CADVISOR_VERSION} https://github.com/google/cadvisor.git /tmp/cadvisor
WORKDIR /tmp/cadvisor
RUN make build

# Base image
FROM alpine:edge
COPY --from=builder /tmp/cadvisor/_output/cadvisor /usr/bin/cadvisor
EXPOSE 8080
ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]