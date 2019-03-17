echo "Adicionando Dependencias"
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

echo "Instalando Docker"
yum install docker-ce-18.06.3.ce-3.el7
systemctl enable docker && sudo systemctl start docker
groupadd docker
usermod -aG docker $USER

echo "Instalando kubernetes ferramentas"
yum install kubelet-1.12.6-0 kubeadm-1.12.6-0 kubectl-1.12.6-0
sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl enable kubelet && sudo systemctl start kubelet

echo "Disabilitando Firewall"
sudo systemctl disable firewalld
sudo systemctl stop firewalld

echo "Sucesso"
"Continuar para instalação 3"
