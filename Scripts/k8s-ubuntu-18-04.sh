curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&\
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&\
sudo apt-get update &&\
sudo apt-get install -y docker-ce &&\
sudo apt-mark hold docker-ce
sudo cat << EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker
sudo docker version


curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - &&\
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update &&\
sudo apt-get install -y kubelet=1.18.2-00 kubeadm=1.18.2-00 kubectl=1.18.2-00 &&\
sudo apt-mark hold kubelet kubeadm kubectl &&\
sudo kubeadm version


sudo kubeadm init --pod-network-cidr=150.15.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl version

JOIN command
1.
sudo openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
    | openssl rsa -pubin -outform der 2>/dev/null \
    | openssl dgst -sha256 -hex \
    | sed 's/^.* //'

2.
sudo kubeadm token list

3
kubeadm join ip:6443 \
    --token=<from Step 2> \
    --discovery-token-ca-cert-hash sh2256:<from Step 1>



echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo systctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -p

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml


kubectl get nodes

________________________________________

cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
EOF
kubectl get pods
kubectl describe pod nginx
kubectl delete pod nginx



kubectl get nodes
kubectl describe node $node_name




cat << EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.4
        ports:
        - containerPort: 80
EOF
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - name: busybox
    image: radial/busyboxplus:curl
    args:
    - sleep
    - "1000"
EOF
kubectl get pods -o wide
kubectl exec busybox -- curl $nginx_pod_ip


kubectl get pods -n kube-system
sudo systemctl status kubelet




cat <<EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.4
        ports:
        - containerPort: 80
EOF
kubectl get deployments
kubectl describe deployment nginx-deployment
kubectl get pods



cat << EOF | kubectl create -f -
kind: Service
apiVersion: v1
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
  type: NodePort
EOF
kubectl get svc
curl localhost:30080


cat << EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  name: store-products
spec:
  selector:
    app: store-products
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
  type: NodePort
EOF



cd ~/
git clone https://github.com/linuxacademy/robot-shop.git
kubectl create namespace robot-shop
kubectl -n robot-shop create -f ~/robot-shop/K8s/descriptors/
kubectl get pods -n robot-shop -w
http://$kube_server_public_ip:30080
