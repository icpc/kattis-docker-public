FROM alpine

ENV KOTLIN_VERSION 1.1.4

RUN apk add --no-cache curl zip

RUN cd /tmp && curl -L -o kotlinc.zip https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip && unzip kotlinc.zip

FROM openjdk:8u181-slim

COPY --from=0 /tmp/kotlinc /usr/local/kotlinc
RUN cd /usr/local/bin && ln -s ../kotlinc/bin/* .

RUN apt-get update && apt-get install -y make time

WORKDIR /usr/src/myapp
VOLUME /usr/src/myapp

