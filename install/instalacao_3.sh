echo "Iniciando Cluster"
ip="$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}'| grep -m "1" .)"
kubeadm init --apiserver-advertise-address="$(echo $ip)" --pod-network-cidr=10.244.0.0/16

echo "Adicionar configs"
mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "deploy Flannel"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

echo "Sucesso"
kubectl get pods --all-namespaces

echo "Instalação finalizada"