sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo mkdir -p /etc/nginx/tcpconf.d
echo "include /etc/nginx/tcpconf.d/*;" | sudo tee -a /etc/nginx/nginx.conf

CONTROLLER0_IP=172.31.35.84
CONTROLLER1_IP=172.31.38.248

cat << EOF | sudo tee /etc/nginx/tcpconf.d/kubernetes.conf
stream {
    upstream kubernetes {
        server $CONTROLLER0_IP:6443;
        server $CONTROLLER1_IP:6443;
    }

    server {
        listen 6443;
        listen 443;
        proxy_pass kubernetes;
    }
}
EOF

sudo nginx -s reload

curl -k https://localhost:6443/version