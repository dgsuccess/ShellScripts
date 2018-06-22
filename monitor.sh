#!/bin/bash

PID_NAME=TaskCPv4G #设置监控业务进程名称
INTERVAL=5 #设置采集间隔
UDP_SRV_IP=xxxxx #设置UDP IP地址
UDP_SRV_PORT=6688  #设置UDP端口
PID=`ps -ef|grep $PID_NAME|grep -v 'grep'|awk '{print $2}'` #获取进程pid
PPP_TRAFFIC_RECEIVE_INIT=`cat /proc/net/dev|grep ppp0|awk '{print $2}'` #初始化接收流量值
PPP_TRAFFIC_TRANSMIT_INIT=`cat /proc/net/dev|grep ppp0|awk '{print $10}'` #初始化发送流量值
while true
do
	INIT_TIME=`date +"%y-%m-%d %H:%M:%S"` #获取当前系统时间
	MEM_TOTAL=`cat /proc/meminfo |sed -n '1p'|awk '{print $2}'` #获取总体内存大小（KB）
	MEM_FREE=`cat /proc/meminfo |sed -n '3p'|awk '{print $2}'` #获取总体内存剩余大小（KB)
    MEM_USED=`echo "$MEM_TOTAL-$MEM_FREE"|bc` #获取总体内存已用大小（KB）
	CPU_IDEL=`top -b -n 1|sed -n '3p'|awk '{print $8}'` #获取总体CPU空闲大小（%）
	PPP_TRAFFIC_RECEIVE_CURRENT=`cat /proc/net/dev|grep ppp0|awk '{print $2}'`  #获取当前最新的4G接收流量（bytes)
    PPP_TRAFFIC_TRANSMIT_CURRENT=`cat /proc/net/dev|grep ppp0|awk '{print $10}'` #获取当前最新的4G发送流量（bytes)
	PPP_TRAFFIC_RECEIVE=`echo "($PPP_TRAFFIC_RECEIVE_CURRENT-$PPP_TRAFFIC_RECEIVE_INIT)/$INTERVAL"|bc` #计算每秒4G接收流量变化值（bytes）
	PPP_TRAFFIC_TRANSMIT=`echo "($PPP_TRAFFIC_TRANSMIT_CURRENT-$PPP_TRAFFIC_TRANSMIT_INIT)/$INTERVAL"|bc` #计算每秒4G发送流量变化值（bytes）
	DISK_USED=`df -k|sed -n '2p'|awk '{print $3}'` #获取磁盘已用空间（KB)
	DISK_FREE=`df -k|sed -n '2p'|awk '{print $4}'` #获取磁盘剩余空间（KB)
	DISK_TOTAL=6779240 #固定磁盘总空间（KB）
	PID_CPU_PERCENT=`top -b -n 1 -p $PID|tail -1|awk '{print $9}'` #获取进程CPU占用大小（%）
	PID_RSS_KB=`cat /proc/$PID/status|grep VmRSS|awk '{print $2}'` #获取进程内存占用大小（KB）
    PPP_TRAFFIC_RECEIVE_INIT=$PPP_TRAFFIC_RECEIVE_CURRENT #将最近一次获得的4G当前接收流量赋值给初始化接收流量变量
    PPP_TRAFFIC_TRANSMIT_INIT=$PPP_TRAFFIC_TRANSMIT_CURRENT #将最近一次获得的4G当前发送流量赋值给初始化发送流量变量
    data="time:"${INIT_TIME}",""mem_total:"${MEM_TOTAL}",""mem_free:"${MEM_FREE}",""mem_used:"${MEM_USED}",""cpu_idel:"${CPU_IDEL}",""ppp_traffic_receive:"${PPP_TRAFFIC_RECEIVE}",""ppp_traffic_transmit:"${PPP_TRAFFIC_TRANSMIT}",""disk_total:"${DISK_TOTAL}",""disk_used:"${DISK_USED}",""disk_free:"${DISK_FREE}",""pid_cpu_percent:"${PID_CPU_PERCENT}",""pid_rss:"${PID_RSS_KB}
    echo $data
    sleep $INTERVAL
done|/usr/bin/socat - udp-datagram:$UDP_SRV_IP:$UDP_SRV_PORT #将数据推送至服务器