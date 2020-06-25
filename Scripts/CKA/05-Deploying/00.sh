The YAML for a deployment:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubeserve
spec:
  replicas: 3
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
      - image: linuxacademycontent/kubeserve:v1
        name: app


Create a deployment with a record (for rollbacks):
kubectl create -f kubeserve-deployment.yaml --record

Check the status of the rollout:
kubectl rollout status deployments kubeserve


View the ReplicaSets in your cluster:
kubectl get replicasets


Scale up your deployment by adding more replicas:
kubectl scale deployment kubeserve --replicas=5


Expose the deployment and provide it a service:
kubectl expose deployment kubeserve --port 80 --target-port 80 --type NodePort


Set the minReadySeconds attribute to your deployment:
kubectl patch deployment kubeserve -p '{"spec": {"minReadySeconds": 10}}'


Use kubectl apply to update a deployment:
kubectl apply -f kubeserve-deployment.yaml


Use kubectl replace to replace an existing deployment:
kubectl replace -f kubeserve-deployment.yaml

Run this curl look while the update happens:
while true; do curl http://10.105.31.119; done


Perform the rolling update:
kubectl set image deployments/kubeserve app=linuxacademycontent/kubeserve:v2 --v 6


Describe a certain ReplicaSet:
kubectl describe replicasets kubeserve-[hash]


Apply the rolling update to version 3 (buggy):
kubectl set image deployment kubeserve app=linuxacademycontent/kubeserve:v3


Undo the rollout and roll back to the previous version:
kubectl rollout undo deployments kubeserve


Look at the rollout history:
kubectl rollout history deployment kubeserve


Roll back to a certain revision:
kubectl rollout undo deployment kubeserve --to-revision=2

Pause the rollout in the middle of a rolling update (canary release):
kubectl rollout pause deployment kubeserve


Resume the rollout after the rolling update looks good:
kubectl rollout resume deployment kubeserve


#---------------------------------------------------------
Configuring an Application for High Availability and Scale


The YAML for a readiness probe:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubeserve
spec:
  replicas: 3
  selector:
    matchLabels:
      app: kubeserve
  minReadySeconds: 10
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      name: kubeserve
      labels:
        app: kubeserve
    spec:
      containers:
      - image: linuxacademycontent/kubeserve:v3
        name: app
        readinessProbe:
          periodSeconds: 1
          httpGet:
            path: /
            port: 80


Apply the readiness probe:
kubectl apply -f kubeserve-deployment-readiness.yaml


View the rollout status:
kubectl rollout status deployment kubeserve


Describe deployment:
kubectl describe deployment

Create a ConfigMap with two keys:
kubectl create configmap appconfig --from-literal=key1=value1 --from-literal=key2=value2



Get the YAML back out from the ConfigMap:
kubectl get configmap appconfig -o yaml


The YAML for the ConfigMap pod:
apiVersion: v1
kind: Pod
metadata:
  name: configmap-pod
spec:
  containers:
  - name: app-container
    image: busybox:1.28
    command: ['sh', '-c', "echo $(MY_VAR) && sleep 3600"]
    env:
    - name: MY_VAR
      valueFrom:
        configMapKeyRef:
          name: appconfig
          key: key1


Create the pod that is passing the ConfigMap data:
kubectl apply -f configmap-pod.yaml


Get the logs from the pod displaying the value:
kubectl logs configmap-pod


The YAML for a pod that has a ConfigMap volume attached:
apiVersion: v1
kind: Pod
metadata:
  name: configmap-volume-pod
spec:
  containers:
  - name: app-container
    image: busybox
    command: ['sh', '-c', "echo $(MY_VAR) && sleep 3600"]
    volumeMounts:
      - name: configmapvolume
        mountPath: /etc/config
  volumes:
    - name: configmapvolume
      configMap:
        name: appconfig


Create the ConfigMap volume pod:
kubectl apply -f configmap-volume-pod.yaml


Get the keys from the volume on the container:
kubectl exec configmap-volume-pod -- ls /etc/config


Get the values from the volume on the pod:
kubectl exec configmap-volume-pod -- cat /etc/config/key1


The YAML for a secret:
apiVersion: v1
kind: Secret
metadata:
  name: appsecret
stringData:
  cert: value
  key: value


Create the secret:
kubectl apply -f appsecret.yaml



The YAML for a pod that will use the secret:
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  containers:
  - name: app-container
    image: busybox
    command: ['sh', '-c', "echo Hello, Kubernetes! && sleep 3600"]
    env:
    - name: MY_CERT
      valueFrom:
        secretKeyRef:
          name: appsecret
          key: cert


Create the pod that has attached secret data:
kubectl apply -f secret-pod.yaml

Open a shell and echo the environment variable:
kubectl exec -it secret-pod -- sh
echo $MY_CERT


The YAML for a pod that will access the secret from a volume:
apiVersion: v1
kind: Pod
metadata:
  name: secret-volume-pod
spec:
  containers:
  - name: app-container
    image: busybox
    command: ['sh', '-c', "echo $(MY_VAR) && sleep 3600"]
    volumeMounts:
      - name: secretvolume
        mountPath: /etc/certs
  volumes:
    - name: secretvolume
      secret:
        secretName: appsecret


Create the pod with volume attached with secrets:
kubectl apply -f secret-volume-pod.yaml

Get the keys from the volume mounted to the container with the secrets:
kubectl exec secret-volume-pod -- ls /etc/certs