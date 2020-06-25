kubectl get pods -o wide
kubectl drain [node_name] --ignore-daemonsets
kubectl get nodes -w
kubectl uncordon [node_name]
kubectl delete node [node_name]
sudo kubeadm token generate
sudo kubeadm token list
sudo kubeadm token create [token_name] --ttl 2h --print-join-command