FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEPREFIX=/root/.wine
ENV WINEARCH=win64
ENV DISPLAY=:0

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    dpkg --add-architecture i386 \
    && apt update \
    && apt install -y --no-install-recommends \
        wine \
        wine32 \
        wine64 \
        winbind \
        xvfb \
        xauth \
        cabextract \
        fontconfig \
        fonts-freefont-ttf \
        ca-certificates \
        bash \
    && rm -rf /var/lib/apt/lists/*

RUN winecfg >/dev/null 2>&1 || true

RUN mkdir -p /root/.wine/drive_c/bin

COPY bin/ /root/.wine/drive_c/bin/
COPY drive_c/ext-7.8.0/ /root/.wine/drive_c/ext-7.8.0/
COPY drive_c/ext-7.9.0/ /root/.wine/drive_c/ext-7.9.0/
COPY drive_c/uni-1.95.0.1607/ /root/.wine/drive_c/uni-1.95.0.1607/

VOLUME ["/root/.wine/drive_c/bin/log"]
WORKDIR /root/.wine/drive_c/bin
EXPOSE 8078
CMD ["bash", "-c", "Xvfb :0 -screen 0 1024x768x16 & wine /root/.wine/drive_c/bin/frontMSS.exe"]
