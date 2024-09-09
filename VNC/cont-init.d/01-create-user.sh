#!/command/execlineb -P
/package/admin/s6-overlay/command/with-contenv bash -c "

# Access environment variables
USERNAME=\${USERNAME:-defaultuser}
PASSWORD=\${PASSWORD:-defaultpassword}
SHELL=\${SHELL:-/bin/bash}
RESOLUTION=\${RESOLUTION:-1024x768}




useradd -m -s \${SHELL} \"\$USERNAME\"
echo \"\$USERNAME:\$PASSWORD\" | chpasswd


echo \"User \$USERNAME created with the provided password.\"
mkdir /home/\${USERNAME}/.vnc
mv /xstartup /home/\${USERNAME}/.vnc/xstartup
mv /vncstart.sh /home/\${USERNAME}/.vncstart.sh


chown \${USERNAME}:\${USERNAME} /home/\${USERNAME}/.vnc
chown \${USERNAME}:\${USERNAME} /home/\${USERNAME}/.vnc/xstartup
chown \${USERNAME}:\${USERNAME} /home/\${USERNAME}/.vncstart.sh

chmod u+x /home/\${USERNAME}/.vnc/xstartup
chmod u+x /home/\${USERNAME}/.vncstart.sh

service ssh start


sed -i 's/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/#%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers 
sed -i 's/^root*/#root/g' /etc/sudoers


exec gosu \"${USERNAME}\" bash -c \"ibus-daemon --xim -d && cd /home/\${USERNAME} && export RESOLUTION=\${RESOLUTION} && sh /home/\${USERNAME}/.vncstart.sh\"

"