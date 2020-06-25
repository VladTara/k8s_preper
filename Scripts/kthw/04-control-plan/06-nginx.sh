# on masters
sudo apt-get install -y nginx
cat << EOF | sudo tee /etc/nginx/sites-available/kubernetes.default.svc.cluster.local
server {
  listen      80;
  server_name kubernetes.default.svc.cluster.local;

  location /healthz {
     proxy_pass                    https://127.0.0.1:6443/healthz;
     proxy_ssl_trusted_certificate /var/lib/kubernetes/ca.pem;
  }
}
EOF

sudo ln -s /etc/nginx/sites-available/kubernetes.default.svc.cluster.local /etc/nginx/sites-enabled/

sudo systemctl enable nginx
sudo systemctl restart nginx
curl -H "Host: kubernetes.default.svc.cluster.local" -i http://127.0.0.1/healthz