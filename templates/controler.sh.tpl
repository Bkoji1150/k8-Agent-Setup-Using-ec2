# STEP ONE:
# ====LAUNCH A T2 MEDIUM, SIZE 10GB, UBUNTU ON AWS====
** run the kubeadm script as a root user:
vi k8.sh
sh k8.sh
** start kubeadm**
kubeadm init ===this will generate a msg and a token
copy the token to add to worker script
#run the msg as normal user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# =================

kubectl get all
kubectl get node
# =============
Run this command to get Master ready
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


# ======================================================================

#!/bin/bash
# Common stages for both master and worker nodes
# This can be use as user data in launch template or launch configutions

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo apt update -y
sudo apt install -y apt-transport-https -y

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt update -y
sudo apt install -y kubelet kubeadm containerd kubectl
# apt-mark hold will prevent the package from being automatically upgraded or removed.

sudo apt-mark hold kubelet kubeadm kubectl containerd

sudo cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Enable and start kubelet service
sudo systemctl daemon-reload
sudo systemctl start kubelet
sudo systemctl enable kubelet.service

# ============================================

Launch worker node server in Aws
Add the script as user data during configuration
***remember to add the token ** very important**

# ================================================
#!/bin/bash
# Common stages for both master and worker nodes
# This can be use as user data in launch template or launch configutions
sudo hostname node1
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo apt update -y
sudo apt install -y apt-transport-https -y

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt update -y
sudo apt install -y kubelet kubeadm containerd kubectl
# apt-mark hold will prevent the package from being automatically upgraded or removed.

sudo apt-mark hold kubelet kubeadm kubectl containerd

sudo cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Enable and start kubelet service
sudo systemctl daemon-reload
sudo systemctl start kubelet
sudo systemctl enable kubelet.service

kubeadm join 172.31.81.129:6443 --token xjkbcy.3bj5vibsd1ipdcfo \
	--discovery-token-ca-cert-hash sha256:24c3647677eb88c98f83d9c42d6058bac12a80af44d92f789a7641dab6e22d4f

# ===========================================================================

Use Launch Template to create ASG
	1. Launch Template
	2. Add LT name --mynode
	3. Ami (choose ubuntu)
	4. Chose vpc
	5. Choose subnet
	6. Use existing SG
	7. Add user data (node script)
====go to ASG==
Create auto scaling group
From the  launch template
