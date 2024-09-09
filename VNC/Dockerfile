FROM ubuntu:24.04

ARG S6_OVERLAY_VERSION=3.2.0.0
COPY mozilla-firefox /etc/apt/preferences.d/mozilla
# COPY 51unattended-upgrades-firefox /etc/apt/apt.conf.d/51unattended-upgrades-firefox


COPY xstartup /xstartup
COPY vncstart.sh /vncstart.sh

RUN export DEBIAN_FRONTEND=noninteractive &&\
    apt update &&\
    apt install -y kde-plasma-desktop konsole kwin-x11 x11-xserver-utils dbus-x11  tigervnc-standalone-server novnc websockify sudo vim locales wget curl &&\
    apt install -y software-properties-common &&\
    locale-gen en_US.UTF-8 &&\
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 &&\
    apt remove chromium-* -y && apt autoremove -y && sudo install -d -m 0755 /etc/apt/keyrings &&\
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null &&\
    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}' &&\
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null &&\
    sudo apt-get update && sudo apt-get install -y firefox && apt remove -y fcitx* && apt autoremove -y &&\
    apt install  -y xz-utils passwd gosu openssh-server ibus ibus-* fonts-noto-cjk-* 



ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz



COPY cont-init.d/ /etc/cont-init.d/
COPY cont-finish.d /etc/cont-finish.d/
RUN chmod +x /etc/cont-init.d/* && chmod +x /etc/cont-finish.d/*

ENTRYPOINT ["/init"]

EXPOSE 9000/tcp
EXPOSE 5901/tcp
EXPOSE 22/tcp
CMD ["s6-svscan", "/etc/services.d"]
    
   