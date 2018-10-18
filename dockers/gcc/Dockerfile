FROM gcc:7.3.0

FROM debian:jessie-slim
COPY --from=0 /usr/local/lib/gcc /usr/local/lib/gcc
COPY --from=0 /usr/local/libexec/gcc /usr/local/libexec/gcc
COPY --from=0 /usr/local/lib64 /usr/local/lib64
COPY --from=0 /usr/local/bin /usr/local/bin

WORKDIR /usr/src/myapp
VOLUME /usr/src/myapp

