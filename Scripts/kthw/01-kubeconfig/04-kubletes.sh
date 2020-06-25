#KUBERNETES_ADDRESS=<load balancer private ip>
#NODES="<worker 1 hostname> <worker 2 hostname>"
# kubelets
#
KUBERNETES_ADDRESS=172.31.43.193
NODES="ichcc4c.mylabserver.com ichcc5c.mylabserver.com"
for instance in ${NODES}; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig
  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig
  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig
  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done
