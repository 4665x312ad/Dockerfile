FROM alpine:latest
ENV NOVNC_VERSION=v1.2.0 \
    VNC_PORT=2000 \
    VNC_RESOLUTION=1280x800 \
    NOVNC_PORT=8099
RUN apk update && \
    apk add --no-cache qemu-system-x86_64 zenhei-font-ttf xz dbus curl firefox-esr gnome-system-monitor mate-system-monitor git xfce4 xfce4-terminal tightvncserver wget && \
    apk add --no-cache --virtual .build-deps tar && \
    wget https://github.com/novnc/noVNC/archive/refs/tags/${NOVNC_VERSION}.tar.gz && \
    tar -xvf ${NOVNC_VERSION}.tar.gz && \
    mv noVNC-${NOVNC_VERSION} /noVNC && \
    rm ${NOVNC_VERSION}.tar.gz && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*
RUN mkdir $HOME/.vnc && \
    echo 'chu' | vncpasswd -f > $HOME/.vnc/passwd && \
    chmod 600 $HOME/.vnc/passwd
RUN echo '#!/bin/sh' > /chu.sh && \
    echo 'cd /' >> /chu.sh && \
    echo "vncserver :${VNC_PORT} -geometry ${VNC_RESOLUTION}" >> /chu.sh && \
    echo 'cd /noVNC' >> /chu.sh && \
    echo "./utils/launch.sh --vnc localhost:${VNC_PORT} --listen ${NOVNC_PORT}" >> /chu.sh && \
    chmod 755 /chu.sh
HEALTHCHECK CMD netstat -tuln | grep -q ${NOVNC_PORT} || exit 1
EXPOSE ${NOVNC_PORT}
CMD ["/bin/sh", "/chu.sh"]
