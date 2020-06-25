In this lesson, we’ll go through the power of ReplicaSets, which make your application self-healing by replicating pods and moving them around and spinning them up when nodes fail. We’ll also talk about StatefulSets and the benefit they provide.

The YAML for a ReplicaSet:

apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myreplicaset
  labels:
    app: app
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: main
        image: linuxacademycontent/kubeserve
Create the ReplicaSet:

kubectl apply -f replicaset.yaml
The YAML for a pod with the same label as a ReplicaSet:

apiVersion: v1
kind: Pod
metadata:
  name: pod1
  labels:
    tier: frontend
spec:
  containers:
  - name: main
    image: linuxacademycontent/kubeserve
Create the pod with the same label:

kubectl apply -f pod-replica.yaml
Watch the pod get terminated:

kubectl get pods -w 
The YAML for a StatefulSet:

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
Create the StatefulSet:

kubectl apply -f statefulset.yaml
View all StatefulSets in the cluster:

kubectl get statefulsets
Describe the StatefulSets:

kubectl describe statefulsets