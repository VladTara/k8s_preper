Volume access modes are how you specify the access of a node to your Persistent Volume. There are three types of access modes: ReadWriteOnce, ReadOnlyMany, and ReadWriteMany. In this lesson, we will explain what each of these access modes means and two VERY IMPORTANT things to remember when using your Persistent Volumes with pods.

The YAML for a Persistent Volume:

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
View the Persistent Volumes in your cluster:

kubectl get pv