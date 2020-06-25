sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler --now
sudo systemctl status kube-apiserver kube-controller-manager kube-scheduler

kubectl get componentstatuses --kubeconfig admin.kubeconfig