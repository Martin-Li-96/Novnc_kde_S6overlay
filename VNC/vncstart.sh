#!/bin/bash
vncserver \
    -localhost no \
    -geometry ${RESOLUTION} \
    -SecurityTypes None --I-KNOW-THIS-IS-INSECURE \
    :1 

websockify \
    --web /usr/share/novnc/ \
    9000 \
    localhost:5901

\bin\bash -c " sleep infinity"


