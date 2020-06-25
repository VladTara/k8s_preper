
kubectl get services

cat << EOF | kubectl create -f - 
apiVersion: v1
kind: Service
metadata:
  name: nginx-loadbalancer
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: nginx
EOF

kubectl run kubeserve2 --image=chadmcrowell/kubeserve2
kubectl get deployments
kubectl scale deployment/kubeserve2 --replicas=2
kubectl get pods -o wide
kubectl expose deployment kubeserve2 --port 80 --target-port 8080 --type LoadBalancer
kubectl get services
kubectl get services -w
kubectl get services kubeserve2 -o yaml

curl http://[external-ip]
kubectl describe services kubeserve

kubectl annotate service kubeserve2 externalTrafficPolicy=Local

cat << EOF | kubectl apply -f - 
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: service-ingress
spec:
  rules:
  - host: kubeserve.example.com
    http:
      paths:
      - backend:
          serviceName: kubeserve2
          servicePort: 80
  - host: app.example.com
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
  - http:
      paths:
      - backend:
          serviceName: httpd
          servicePort: 80
EOF
kubectl edit ingress
kubectl describe ingress
curl http://kubeserve2.example.com