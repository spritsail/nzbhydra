FROM spritsail/alpine:3.9

ARG NZBHYDRA_VER=2.3.11
ARG NZBHYDRA_URL="https://github.com/theotherp/nzbhydra2/releases/download/v${NZBHYDRA_VER}/nzbhydra2-${NZBHYDRA_VER}-linux.zip"

ARG YQ_VER=2.2.1
ARG YQ_ARCH=amd64

ENV SUID=907 SGID=900
ENV MAXMEM=256M
ENV NZBHYDRA_DIR=/usr/lib/nzbhydra

LABEL maintainer="Spritsail <nzbhydra@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="NZBHydra 2" \
      org.label-schema.url="https://github.com/theotherp/nzbhydra2" \
      org.label-schema.description="NZBHydra is a meta search for NZB indexers" \
      org.label-schema.version=${NZBHYDRA_VER} \
      io.spritsail.version.nzbhydra=${NZBHYDRA_VER}

WORKDIR $NZBHYDRA_DIR

RUN apk add --no-cache openjdk8 tini \
 && wget -O /tmp/nzbhydra2.zip $NZBHYDRA_URL \
 && unzip -d /tmp /tmp/nzbhydra2.zip \
 && cp /tmp/lib/core-${NZBHYDRA_VER}-exec.jar \
       /tmp/LICENSE /tmp/changelog.md . \
 && wget -O /usr/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_${YQ_ARCH} \
 && chmod 755 /usr/bin/yq \
 && rm -rf /tmp/*

VOLUME ["/config"]
EXPOSE 5076

# Keep version argument for runtime
ENV NZBHYDRA_VER=${NZBHYDRA_VER}

HEALTHCHECK --start-period=20s --timeout=5s \
    CMD wget -SO/dev/null "http://localhost:5076$(yq read /config/nzbhydra.yml main.urlBase)/api/stats?apikey=$(yq read /config/nzbhydra.yml main.apiKey)"

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
