
kubectl get pods -n kube-system
kubectl get deployments -n kube-system
kubectl get services -n kube-system

cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
  - image: busybox:1.28.4
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
  restartPolicy: Always
EOF

kubectl exec -it busybox -- cat /etc/resolv.conf
kubectl exec -it busybox -- nslookup kubernetes
kubectl exec -ti busybox -- nslookup [pod-ip-address].default.pod.cluster.local
kubectl exec -it busybox -- nslookup kube-dns.kube-system.svc.cluster.local
kubectl logs [coredns-pod-name]

cat << EOF | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  name: kube-headless
spec:
  clusterIP: None
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: kubserve2
EOF

cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  namespace: default
  name: dns-example
spec:
  containers:
    - name: test
      image: nginx
  dnsPolicy: "None"
  dnsConfig:
    nameservers:
      - 8.8.8.8
    searches:
      - ns1.svc.cluster.local
      - my.dns.search.suffix
    options:
      - name: ndots
        value: "2"
      - name: edns0
EOF