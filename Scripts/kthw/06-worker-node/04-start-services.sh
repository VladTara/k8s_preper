sudo systemctl daemon-reload
sudo systemctl enable containerd kubelet kube-proxy --now

sudo systemctl status containerd kubelet kube-proxy


kubectl get nodes --kubeconfig /home/cloud_user/admin.kubeconfig