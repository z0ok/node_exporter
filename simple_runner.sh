#!/bin/bash
### A bit more simple version. No lsof check and less output.

### Current settings. If you want to change port or user - change here.
### IF you want to add more params to node_exporter executable - edit node_exporter.service file
USER="node_exporter"
TARGET_PORT="9100"
### Set to true, if you want to delete config and script after execution
### Do not set true, if you unpacked /opt/node_exporter
POST_CLEAN=false

if [ "$EUID" -ne 0 ]
  then echo "[!] Please run as root."
  exit
fi

echo "[*] Creating user $USER"
useradd -rs /bin/false $USER

echo "[*] Preparing directory /opt/node_exporter"
mkdir -p /opt/node_exporter
cp ./node_exporter /opt/node_exporter
chown -R $USER:$USER /opt/node_exporter

echo '[*] Copying config'
cp ./node_exporter.service /etc/systemd/system/

echo '[*] Restarting service'
systemctl daemon-reload
systemctl enable node_exporter
systemctl restart node_exporter

if systemctl is-active --quiet node_exporter; then
    echo "[+] Service running! Check http://127.0.0.1:$TARGET_PORT"
    echo '[+] Dont forget about local firewall if exists!'
else
    echo '[-] For unknown reason service didnt started :('
    exit
fi

if $POST_CLEAN; then
    rm -f ./node_exporter.service
    rm -f ./runner.sh
    if [[ $(pwd) -ef /opt/node_exporter ]]; then
        echo '[+] Cleaned'
    else
        rm -f ./node_exporter
        echo '[+] Cleaned'
    fi
fi
