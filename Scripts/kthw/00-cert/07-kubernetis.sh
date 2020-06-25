CERT_HOSTNAME=\
10.32.0.1,\
<controller node 1 Private IP>,\
<controller node 1 hostname>,\
<controller node 2 Private IP>,\
<controller node 2 hostname>,\
<API load balancer Private IP>,\
<API load balancer hostname>,\
127.0.0.1,\
localhost,\
kubernetes.default



CERT_HOSTNAME=\
10.32.0.1,\
172.31.43.193,\
ichcc1c.mylabserver.com,\
172.31.38.248,\
ichcc2c.mylabserver.com,\
172.31.35.84,\
ichcc3c.mylabserver.com,\
127.0.0.1,\
localhost,\
kubernetes.default

MASTER1_IP_PUB=35.178.197.64
MASTER2_IP_PUB=3.8.196.65
cat > kubernetes-csr.json << EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${CERT_HOSTNAME} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

scp \
  ca.pem \
  ca-key.pem \
  kubernetes-key.pem \
  kubernetes.pem \
  service-account-key.pem \
  service-account.pem \
  cloud_user@${MASTER1_IP_PUB}:~

scp \
  ca.pem \
  ca-key.pem \
  kubernetes-key.pem \
  kubernetes.pem \
  service-account-key.pem \
  service-account.pem \
  cloud_user@${MASTER2_IP_PUB}:~