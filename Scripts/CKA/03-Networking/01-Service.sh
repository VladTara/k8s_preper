cat << EOF | kubectl creat -f -
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
  selector:
    app: nginx
EOF

kubectl get services -o yaml
ping 10.96.0.1
kubectl get services

kubectl get endpoints
sudo iptables-save | grep KUBE | grep nginx