FROM debian
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install qemu-kvm *zenhei* xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system-monitor  git xfce4 xfce4-terminal tightvncserver wget   -y
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN curl -LO https://proot.gitlab.io/proot/bin/proot
RUN chmod 755 proot
RUN mv proot /bin
RUN tar -xvf v1.2.0.tar.gz
RUN mkdir  $HOME/.vnc
RUN echo 'chu' | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd
RUN echo 'whoami ' >>/chu.sh
RUN echo 'cd ' >>/chu.sh
RUN echo "su -l -c  'vncserver :2000 -geometry 1280x800' "  >>/chu.sh
RUN echo 'cd /noVNC-1.2.0' >>/chu.sh
RUN echo './utils/launch.sh  --vnc localhost:7900 --listen 8099 ' >>/chu.sh
RUN chmod 755 /chu.sh
EXPOSE 8099
CMD  /chu.sh
