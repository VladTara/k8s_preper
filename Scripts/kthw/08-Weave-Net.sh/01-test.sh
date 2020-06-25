kubectl get pods -n kube-system

cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx2
spec:
  selector:
    matchLabels:
      app: nginx2
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx2
    spec:
      containers:
      - name: my-nginx2
        image: nginx
        ports:
        - containerPort: 80
EOF

kubectl expose deployment/nginx


kubectl run busybox --image=radial/busyboxplus:curl --command -- sleep 3600

POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")
kubectl get ep nginx

kubectl exec $POD_NAME -- curl <first nginx pod IP address>
kubectl exec $POD_NAME -- curl <second nginx pod IP address>

kubectl get svc
kubectl exec $POD_NAME -- curl <nginx service IP address>