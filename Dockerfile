FROM rust:slim

ARG CYWAD_BASE_API_URL=$CYWAD_BASE_API_URL
ARG CYWAD_RELEASE=$CYWAD_RELEASE

RUN apt update \
    && apt -y install curl build-essential unzip pkg-config libssl-dev

# backend
RUN cd /root \
    && curl -L https://github.com/estin/cywad/archive/$CYWAD_RELEASE.zip --output cywad-release.zip \
    && unzip cywad-release.zip \
    && mv cywad-$CYWAD_RELEASE cywad-release \
    && cd cywad-release \
    && cargo build --release --features devtools,server,png_widget

# frontend
RUN cargo install trunk wasm-bindgen-cli
RUN rustup target add wasm32-unknown-unknown
RUN cd /root/cywad-release/cywad-yew \
    && trunk build --release -d /root/cywad-ui-release

# final stage
FROM justinribeiro/chrome-headless:stable
COPY --from=0 /root/cywad-release/target/release/cywad /usr/bin
COPY --from=0 /root/cywad-ui-release /opt/cywad-static
COPY --from=0 /root/cywad-release/openapi.yaml /opt/cywad-static

USER root
ADD config /opt/cywad-config

EXPOSE $PORT
ENTRYPOINT []
CMD cywad serve \
    --listen=0.0.0.0:$PORT \
    --path-to-config=/opt/cywad-config \
    --path-to-static=/opt/cywad-static \
    --command="google-chrome --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 --headless --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --no-sandbox --enable-logging --allow-running-insecure-content --ignore-certificate-errors"
