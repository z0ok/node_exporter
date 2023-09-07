# Node-exporter installer
Installation pack for node-exporter. Remember, exec version may be outdated, download da fresh on from https://github.com/prometheus/node_exporter
Tested on: Debian / Ubuntu / RHEL7/8 / Alma7/8 

There are 2 scripts: runner.sh and simple_runner.sh. Runner.sh has few more checks and needs lsof to work. Simple one just install and doesn't care.

Fix settings in runners and .service file if you need.

## Setting up firewall

```
sudo firewall-cmd --add-port=port-number/port-type
```
Make the new settings persistent:
```
$ sudo firewall-cmd --runtime-to-permanent
```

