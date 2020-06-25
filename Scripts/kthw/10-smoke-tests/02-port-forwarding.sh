POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8081:80
curl --head http://127.0.0.1:8081