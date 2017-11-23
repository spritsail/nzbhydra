FROM alpine:3.6
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV UID=907 GID=900

RUN apk add --no-cache git python su-exec tini \
 && git clone --depth 1 https://github.com/theotherp/nzbhydra /hydra \
 && apk del --no-cache git \
 && rm -rf /hydra/.git

VOLUME ["/config"]
EXPOSE 8081

ENTRYPOINT [ "/sbin/tini", "--" ]
CMD chown -R "$UID:$GID" /hydra && \
    exec su-exec "$UID:$GID" \
        python -u /hydra/nzbhydra.py --nobrowser \
        --config /config/settings.cfg \
        --database /config/nzbhydra.db
