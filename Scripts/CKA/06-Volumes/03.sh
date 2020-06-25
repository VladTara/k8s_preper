here’s an even easier way to provision storage in Kubernetes with StorageClass objects. Also, your storage is safe from data loss with the “Storage Object in Use Protection” feature, which ensures any pods using a Persistent Volume will not lose the data on the volume as long as it is actively mounted. We’ve been using Google Storage for this section, but there are many different volume types you can use in Kubernetes. In this lesson, we will talk about the hostPath volume and the empty directory volume type.

See the PV protection on your volume:

kubectl describe pv mongodb-pv
See the PVC protection for your claim:

kubectl describe pvc mongodb-pvc
Delete the PVC:

kubectl delete pvc mongodb-pvc
See that the PVC is terminated, but the volume is still attached to pod:

kubectl get pvc
Try to access the data, even though we just deleted the PVC:

kubectl exec -it mongodb mongo
use mystore
db.foo.find()
Delete the pod, which finally deletes the PVC:

kubectl delete pods mongodb
Show that the PVC is deleted:

kubectl get pvc
YAML for a StorageClass object:

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
Create the StorageClass type "fast":

kubectl apply -f sc-fast.yaml
Change the PVC to include the new StorageClass object:

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc 
spec:
  storageClassName: fast
  resources:
    requests:
      storage: 100Mi
  accessModes:
    - ReadWriteOnce
Create the PVC with automatically provisioned storage:

kubectl apply -f mongodb-pvc.yaml
View the PVC with new StorageClass:

kubectl get pvc
View the newly provisioned storage:

kubectl get pv
The YAML for a hostPath PV:

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-hostpath
spec:
  storageClassName: local-storage
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
The YAML for a pod with an empty directory volume:

apiVersion: v1
kind: Pod
metadata:
  name: emptydir-pod
spec:
  containers:
  - image: busybox
    name: busybox
    command: ["/bin/sh", "-c", "while true; do sleep 3600; done"]
    volumeMounts:
    - mountPath: /tmp/storage
      name: vol
  volumes:
  - name: vol
    emptyDir: {}