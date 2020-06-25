kubectl version --short
kubectl describe nodes
kubectl get po [controller_pod_name] -o yaml -n kube-system
sudo apt-mark unhold kubeadm kubelet kubelet
sudo apt install -y kubeadm=1.16.6-9-00 kubelet=1.16.9-00
sudo apt-mark hold kubeadm kubelet kubelet
kubeadm version
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.16.9
sudo apt install -y kubelet=1.16.9-00
sudo apt-mark hold kubeadm kubelet kubelet