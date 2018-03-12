FROM alpine:3.7
LABEL maintainer="Adam Dodman <docker@adam-ant.co.uk>"

ENV SUID=907 SGID=900
ENV MAXMEM=128M
ENV NZBHYDRA_DIR=/usr/lib/nzbhydra

ARG NZBHYDRA_VER=1.4.6
ARG NZBHYDRA_URL="https://github.com/theotherp/nzbhydra2/releases/download/v${NZBHYDRA_VER}/nzbhydra2-${NZBHYDRA_VER}-linux.zip"

LABEL org.label-schema.name="NZBHydra 2" \
      org.label-schema.vcs-url="https://github.com/theotherp/nzbhydra2" \
      org.label-schema.version=$NZBHYDRA_VER \
      org.label-schema.schema-version="1.0"

RUN apk add --no-cache openjdk8 tini \
 && wget -O /sbin/su-exec https://github.com/frebib/su-exec/releases/download/v0.3/su-exec-alpine-$(uname -m) \
 && chmod 755 /sbin/su-exec

WORKDIR $NZBHYDRA_DIR

RUN wget -O /tmp/nzbhydra2.zip $NZBHYDRA_URL \
 && unzip -d /tmp /tmp/nzbhydra2.zip \
 && cp /tmp/lib/core-${NZBHYDRA_VER}-exec.jar \
       /tmp/LICENSE /tmp/changelog.md . \
 && rm -rf /tmp/*

VOLUME ["/config"]
EXPOSE 5076

# Keep version argument for runtime
ENV NZBHYDRA_VER=${NZBHYDRA_VER}

ENTRYPOINT ["/sbin/tini", "--", "su-exec", "--env"]
CMD mkdir -p /config/logs && \
    exec java -Xmx${MAXMEM} -DfromWrapper -noverify \
        -XX:TieredStopAtLevel=1 \
        -Xloggc:/config/logs/gclog-$(date +"%F_%H-%M-%S").log \
        -XX:+PrintGCDetails \
        -XX:+PrintGCTimeStamps \
        -XX:+PrintTenuringDistribution \
        -XX:+PrintGCCause \
        -XX:+UseGCLogFileRotation \
        -XX:NumberOfGCLogFiles=10 \
        -XX:GCLogFileSize=5M \
        -Dspring.output.ansi.enabled=ALWAYS \
        -jar $NZBHYDRA_DIR/core-${NZBHYDRA_VER}-exec.jar \
        --datafolder /config
