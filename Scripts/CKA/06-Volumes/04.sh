In this lesson, we’ll wrap everything up in a nice little bow and create a deployment that will allow us to use our storage with our pods. This is to demonstrate how a real-world application would be deployed and used for storing data.

The YAML for our StorageClass object:

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
The YAML for our PVC:

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: kubeserve-pvc 
spec:
  storageClassName: fast
  resources:
    requests:
      storage: 100Mi
  accessModes:
    - ReadWriteOnce
Create our StorageClass object:

kubectl apply -f storageclass-fast.yaml
View the StorageClass objects in your cluster:

kubectl get sc
Create our PVC:

kubectl apply -f kubeserve-pvc.yaml
View the PVC created in our cluster:

kubectl get pvc
View our automatically provisioned PV:

kubectl get pv
The YAML for our deployment:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubeserve
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubeserve
  template:
    metadata:
      name: kubeserve
      labels:
        app: kubeserve
    spec:
      containers:
      - env:
        - name: app
          value: "1"
        image: linuxacademycontent/kubeserve:v1
        name: app
        volumeMounts:
        - mountPath: /data
          name: volume-data
      volumes:
      - name: volume-data
        persistentVolumeClaim:
          claimName: kubeserve-pvc
Create our deployment and attach the storage to the pods:

kubectl apply -f kubeserve-deployment.yaml
Check the status of the rollout:

kubectl rollout status deployments kubeserve
Check the pods have been created:

kubectl get pods
Connect to our pod and create a file on the PV:

kubectl exec -it [pod-name] -- touch /data/file1.txt
Connect to our pod and list the contents of the /data directory:

kubectl exec -it [pod-name] -- ls /data