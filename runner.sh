if id 'node_exporter' &>/dev/null; then
    echo '[+] User found'
else
    echo '[-] Creating user'
    useradd -rs /bin/false node_exporter
fi
cp ./node_exporter.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable node_exporter
systemctl restart node_exporter
