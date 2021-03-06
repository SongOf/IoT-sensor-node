#!/bin/bash

source /etc/kubernetes/k8s.conf

while true
do
        nc -w2 $K8S_MASTER1_IP 8080 > /dev/null
        m1=$?

        if [ $m1 -eq 0 ]; then
                echo "MASTER_IP=$K8S_MASTER1_IP" > /etc/kubernetes/masterip.conf
		sed -i 's/--api-servers=.*/--api-servers=http:\/\/${K8S_MASTER1_IP}:8080,http:\/\/${K8S_MASTER2_IP}:8080,http:\/\/${K8S_MASTER3_IP}:8080 \\/1' /lib/systemd/system/k8s-worker.service
                systemctl daemon-reload
                systemctl stop k8s-worker.service
                systemctl start k8s-worker.service
                /opt/bin/master1-na.sh
                break
        fi
        sleep 2
done
