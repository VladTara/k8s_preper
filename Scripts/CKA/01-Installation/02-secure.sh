cat .kube/config | more

kubectl get secrets
kubectl create ns my-ns
kubectl run test --image=chadmcrowell/kubectl-proxy -n my-ns
kubectl get pods -n my-ns
kubectl exec -it <name-of-pod> -n my-ns sh
curl localhost:8001/api/v1/namespaces/my-ns/services
cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl get serviceaccounts