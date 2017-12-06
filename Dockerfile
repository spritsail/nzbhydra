FROM alpine:3.7
MAINTAINER Adam Dodman <adam.dodman@gmx.com>

ENV SUID=907 SGID=900

RUN apk add --no-cache git python tini \
 && wget -O /sbin/su-exec https://github.com/frebib/su-exec/releases/download/v0.3/su-exec-alpine-$(uname -m) \
 && chmod 755 /sbin/su-exec \
 \
 && git clone --depth 1 https://github.com/theotherp/nzbhydra /hydra \
 && chmod -R 777 /hydra \
 && apk del --no-cache git \
 && rm -rf /hydra/.git

VOLUME ["/config"]
EXPOSE 8081

ENTRYPOINT [ "/sbin/tini", "--", "su-exec", "--env"]
CMD [ "python", "-u", "/hydra/nzbhydra.py", "--nobrowser", \
        "--config", "/config/settings.cfg", \
        "--database", "/config/nzbhydra.db" \
]
