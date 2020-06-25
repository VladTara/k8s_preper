echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p


sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&\
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&\

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - &&\


sudo apt-get update &&\
sudo apt-get install -y kubelet=1.12.7-00 kubeadm=1.12.7-00 kubectl=1.12.7-00 docker-ce=18.06.1~ce~3-0~ubuntu &&\
sudo apt-mark hold kubelet kubeadm kubectl docker

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube &&\
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config &&\
sudo chown $(id -u):$(id -g) $HOME/.kube/config

