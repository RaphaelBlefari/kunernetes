#!/bin/bash

hostname=""

while [ "$hostname" != "sair" ]
do    

 # Validando Hostname
  echo "Digite o nome da master. (digite exit para sair)"
  read hostname
  hostname=$(echo "$hostname" | tr '[:upper:]' '[:lower:]')
  echo "hostname: $hostname"
  echo $hostname > etc/hostname 
 # fim

 #inserindo hosts by ip
  ip="$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}'| grep -m "1" .)"
  echo "seu ip é:$ip";
  echo $ip " " $hostname >> etc/hosts
#fim

#desabilitando SELINUX
echo Delabilitando SELINUX
setenforce 0 && sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#FIM

bash -c 'cat <<EOF > /etc/sysctl.conf
net.bridge.bridgeip route get 1 | awk '{print $NF;exit}'-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF'

sysctl --system

bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

init 6

done

