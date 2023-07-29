FROM debian
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    qemu-kvm \
    *zenhei* \
    xz-utils \
    dbus-x11 \
    curl \
    firefox-esr \
    gnome-system-monitor \
    mate-system-monitor \
    git \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    wget
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && tar -xvf v1.2.0.tar.gz
RUN curl -LO https://proot.gitlab.io/proot/bin/proot && chmod 755 proot && mv proot /bin
RUN mkdir $HOME/.vnc && echo 'chu' | vncpasswd -f > $HOME/.vnc/passwd && chmod 600 $HOME/.vnc/passwd
RUN echo 'whoami' >> /chu.sh
RUN echo 'cd' >> /chu.sh
RUN echo "su -l -c 'vncserver :2000 -geometry 1280x800'" >> /chu.sh
RUN echo 'cd /noVNC-1.2.0' >> /chu.sh
RUN echo './utils/launch.sh --vnc localhost:7900 --listen 8099' >> /chu.sh
RUN chmod 755 /chu.sh
EXPOSE 8099
CMD /chu.sh
