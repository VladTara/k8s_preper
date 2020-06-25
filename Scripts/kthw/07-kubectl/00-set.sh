ssh -L 6443:localhost:6443 cloud_user@35.177.100.64

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://localhost:6443

kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem

kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config use-context kubernetes-the-hard-way




kubectl config set-cluster public \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://35.177.100.64:6443

kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem

kubectl config set-context public \
  --cluster=public \
  --user=admin

kubectl config use-context public


kubectl get pods
kubectl get nodes
kubectl version