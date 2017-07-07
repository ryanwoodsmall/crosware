#!/bin/bash

whoami | grep -qi ^root$ || {
  echo "please run as root"
  exit 1
}

busybox="$(which busybox)"
inside="eth0"
outside="wlan0"
network="192.168.0"
netmask="255.255.255.0"
prefix="24"
conffile="/tmp/udhcpd.conf"
tftpdir="/tmp/tftp"

ifconfig ${inside} ${network}.1/${prefix} up

echo 1 | tee /proc/sys/net/ipv4/ip_forward

iptables -t nat -A POSTROUTING -o ${outside} -j MASQUERADE
iptables -A FORWARD -i ${outside} -o ${inside} -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i ${inside} -o ${outside} -j ACCEPT

cat > ${conffile} << EOF
pidfile /tmp/udhcpd.pid
lease_file /tmp/udhcpd.leases
max_leases 101
start ${network}.100
end ${network}.200
interface ${inside}
opt subnet ${netmask}
opt router ${network}.1
opt dns 8.8.8.8 8.8.4.4
EOF

# tftpd - XXX - needs iptables allowances!!!
${busybox} udpsvd -vE 0.0.0.0 69 ${busybox} tftpd -c ${tftpdir} &

${busybox} udhcpd -f ${conffile}
