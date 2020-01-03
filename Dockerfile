FROM alpine:latest

# backend
RUN apk --no-cache add curl rust cargo
RUN cd /root \
    && curl -LO https://github.com/estin/cywad/archive/master.zip \
    && unzip master.zip \
    && cd cywad-master \
    && cargo build --release --features devtools,server,png_widget

# frontend
RUN apk --no-cache add yarn
RUN cd /root \
    && curl -LO https://github.com/estin/cywad-pwa/archive/master.zip \
    && unzip master.zip \
    && cd cywad-pwa-master \
    && yarn install \ 
    && yarn build 


# final stage
FROM zenika/alpine-chrome
COPY --from=0 /root/cywad-master/target/release/cywad /usr/bin
COPY --from=0 /root/cywad-pwa-master/build /opt/cywad-pwa

USER root
ADD config /opt/cywad-config

EXPOSE $PORT
ENTRYPOINT []
CMD cywad serve \
    --listen=0.0.0.0:$PORT \
    --path-to-config=/opt/cywad-config \
    --path-to-static=/opt/cywad-pwa \
    --command="chromium-browser --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --headless --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --no-sandbox --enable-logging --allow-running-insecure-content --ignore-certificate-errors"
