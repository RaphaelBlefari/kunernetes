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

ip="$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}'| grep -m "1" .)"

echo "Iniciando Cluster"
kubeadm init --apiserver-advertise-address="$(echo $ip)" --pod-network-cidr=10.244.0.0/16

echo "Adicionar configs"
mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "deploy Flannel"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

