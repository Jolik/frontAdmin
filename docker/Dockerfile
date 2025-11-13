FROM debian:bookworm-slim
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates libstdc++6 libgcc-s1 libzstd1 zlib1g libcurl4 \
    && rm -rf /var/lib/apt/lists/*
COPY ./etc/fmsoft /etc/fmsoft
COPY --chmod=0755 ./opt/app /opt/app
EXPOSE 8077
STOPSIGNAL SIGINT
ENTRYPOINT ["/opt/app"]
