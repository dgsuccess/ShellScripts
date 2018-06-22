# vim /usr/local/sbin/lvs_dr.sh

#! /bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
ipv=/sbin/ipvsadm
vip=10.0.0.250
rs1=10.0.0.80
rs2=10.0.0.73
ifconfig ens160:0 down
ifconfig ens160:0 $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip dev ens160:0
$ipv -C
$ipv -A -u $vip:37500 -s sh 
$ipv -a -u $vip:37500 -r $rs1:37500 -g
$ipv -a -u $vip:37500 -r $rs2:37500 -g




# vim /usr/local/sbin/lvs_dr_rs.sh

#! /bin/bash
vip=10.0.0.250
ifconfig lo:0 $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip lo:0
echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
