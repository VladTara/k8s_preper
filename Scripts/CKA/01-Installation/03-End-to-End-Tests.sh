kubectl run nginx --image=nginx
kubectl get deployments
kubectl get pods
kubectl port-forward $pod_name 8081:80
curl --head http://127.0.0.1:8081
kubectl logs $pod_name
kubectl exec -it $pod_name -- nginx -v
kubectl expose deployment nginx --port 80 --type NodePort
kubectl get services
curl -I localhost:$node_port
kubectl get nodes
kubectl describe nodes
kubectl describe pods