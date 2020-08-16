FROM alpine:latest

RUN apk --no-cache add curl rust cargo yarn

# backend
ENV CYWAD_RELEASE 0.1.2
RUN cd /root \
    && curl -LO https://github.com/estin/cywad/archive/v$CYWAD_RELEASE.zip \
    && unzip v$CYWAD_RELEASE.zip \
    && cd cywad-$CYWAD_RELEASE \
    && cargo build --release --features devtools,server,png_widget

# frontend
ENV CYWAD_PWA_RELEASE 0.1.1
RUN cd /root \
    && curl -LO https://github.com/estin/cywad-pwa/archive/v$CYWAD_PWA_RELEASE.zip \
    && unzip v$CYWAD_PWA_RELEASE.zip \
    && cd cywad-pwa-$CYWAD_PWA_RELEASE \
    && yarn install \ 
    && yarn build 


RUN cd /root \
    && mv cywad-$CYWAD_RELEASE cywad-release \
    && mv cywad-pwa-$CYWAD_PWA_RELEASE cywad-pwa-release


# final stage
FROM zenika/alpine-chrome
COPY --from=0 /root/cywad-release/target/release/cywad /usr/bin
COPY --from=0 /root/cywad-pwa-release/build /opt/cywad-pwa
COPY --from=0 /root/cywad-release/openapi.yaml /opt/cywad-pwa

USER root
ADD config /opt/cywad-config

EXPOSE $PORT
ENTRYPOINT []
CMD cywad serve \
    --listen=0.0.0.0:$PORT \
    --path-to-config=/opt/cywad-config \
    --path-to-static=/opt/cywad-pwa \
    --command="chromium-browser --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --headless --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --no-sandbox --enable-logging --allow-running-insecure-content --ignore-certificate-errors"
