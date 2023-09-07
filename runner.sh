#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "[!] Please run as root."
  exit
fi

echo '[*] Creating user'

if id 'node_exporter' &>/dev/null; then
    echo '[+] User already exists'
else
    useradd -rs /bin/false node_exporter
    if id 'node_exporter' &>/dev/null; then
        echo '[+] User created'
    else
        echo '[-] Cannot add user for some reason.'
        exit
    fi
fi

if lsof -Pi :9100 -sTCP:LISTEN -t >/dev/null ; then
    echo "[-] 9100 port is already used. Cannot bind there!"
    exit
else
    echo "[+] Port is available"
fi


echo '[*] Copying config'
cp ./node_exporter.service /etc/systemd/system/
echo '[*] Restarting service'
systemctl daemon-reload
systemctl enable node_exporter
systemctl restart node_exporter

if systemctl is-active --quiet node_exporter; then
    echo '[+] Service running! Check http://127.0.0.1:9100'
    echo '[+] Dont forget about local firewall if exists!'
    echo '[*] Reminder:'
    echo '> firewall-cmd --add-port=9100/tcp'
    echo '> firewall-cmd --runtime-to-permanent'
else
    echo '[-] For unknown reason service didnt started :('
    exit
fi

