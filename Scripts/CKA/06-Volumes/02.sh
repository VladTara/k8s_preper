Persistent Volume Claims (PVCs) are a way for an application developer to request storage for the application without having to know where the underlying storage is. The claim is then bound to the Persistent Volume (PV), and it will not be released until the PVC is deleted. In this lesson, we will go through creating a PVC and accessing storage within our persistent disk.

The YAML for a PVC:

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc 
spec:
  resources:
    requests:
      storage: 1Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: ""
Create a PVC:

kubectl apply -f mongodb-pvc.yaml
View the PVC in the cluster:

kubectl get pvc
View the PV to ensure it’s bound:

kubectl get pv
The YAML for a pod that uses a PVC:

apiVersion: v1
kind: Pod
metadata:
  name: mongodb 
spec:
  containers:
  - image: mongo
    name: mongodb
    volumeMounts:
    - name: mongodb-data
      mountPath: /data/db
    ports:
    - containerPort: 27017
      protocol: TCP
  volumes:
  - name: mongodb-data
    persistentVolumeClaim:
      claimName: mongodb-pvc
Create the pod with the attached storage:

kubectl apply -f mongo-pvc-pod.yaml
Access the mogodb shell:

kubectl exec -it mongodb mongo
Find the JSON document created in previous lessons:

db.foo.find()
Delete the mongodb pod:

kubectl delete pod mogodb
Delete the mongodb-pvc PVC:

kubectl delete pvc mongodb-pvc
Check the status of the PV:

kubectl get pv
The YAML for the PV to show its reclaim policy:

apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongodb-pv
spec:
  capacity: 
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
    - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  gcePersistentDisk:
    pdName: mongodb
    fsType: ext4