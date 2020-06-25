# Local machine
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

wget -q --show-progress --https-only --timestamping \
https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 &&\
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64 &&\
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl &&\
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson


curl -fsSL https://get.docker.com -o - | sudo sh -

sudo apt-get update &&\
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add 

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu eoan stable"