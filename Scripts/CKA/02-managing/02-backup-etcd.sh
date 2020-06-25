wget https://github.com/etcd-io/etcd/releases/download/v3.3.12/etcd-v3.3.12-linux-amd64.tar.gz

tar xvf etcd-v3.3.12-linux-amd64.tar.gz
sudo mv etcd-v3.3.12-linux-amd64/etcd* /usr/local/bin

sudo ETCDCTL_API=3 etcdctl snapshot save snapshot.db --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key
ETCDCTL_API=3 etcdctl --help

cd /etc/kubernetes/pki/etcd/
ETCDCTL_API=3 etcdctl --write-out=table snapshot status snapshot.db
sudo tar -zcvf etcd.tar.gz /etc/kubernetes/pki/etcd
scp etcd.tar.gz cloud_user@18.219.235.42:~/
