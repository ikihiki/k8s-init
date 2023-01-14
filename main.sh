#!/bin/bash
source common.sh
source $NODE_NAME.sh

 
## Set hostname
echo $NODE_NAME > /etc/hostname

## Setup mDNS
cat <<- EOF > /etc/NetworkManager/conf.d/mdns.conf
[connection]
connection.mdns=1
EOF

## Set root password
echo root:$ROOT_USER_PASSWORD | chpasswd -e
 
## Setup user
mount /var && mount /home
useradd -m $CREATE_NORMAL_USER -s /bin/bash -g users
echo $CREATE_NORMAL_USER:$NORMAL_USER_PASSWORD | chpasswd -e
echo $CREATE_NORMAL_USER "ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/adminusers

## Create a systemd unit that installs k3s if not installed yet
cat <<- EOF > /etc/systemd/system/ssh-import-id.service
[Unit]
Description=Run ssh-import-id
Wants=network-online.target
After=network.target network-online.target
[Service]
Type=simple
TimeoutStartSec=120
ExecStart=/usr/bin/ssh-import-id $IMPORT_SSH_KEY
RemainAfterExit=yes
KillMode=process
User=$CREATE_NORMAL_USER
[Install]
WantedBy=multi-user.target
EOF


## Download and install the latest k3s installer
curl -L --output k3s_installer.sh https://get.k3s.io && install -m755 k3s_installer.sh /usr/bin/
## Create a systemd unit that installs k3s if not installed yet
cat <<- EOF > /etc/systemd/system/install-rancher-k3s-master.service
[Unit]
Description=Run K3s installer
Wants=network-online.target
After=network.target network-online.target
ConditionPathExists=/usr/bin/k3s_installer.sh
ConditionPathExists=!/usr/local/bin/k3s
[Service]
Type=forking
TimeoutStartSec=120
Environment="K3S_URL=https://$MASTER_NODE_ADDR:6443"
Environment="K3S_TOKEN=$MASTER_NODE_K3S_TOKEN"
Environment="K3S_KUBECONFIG_MODE=644"
Environment="INSTALL_K3S_EXEC=$INSTALL_K3S_EXEC"
ExecStart=/usr/bin/k3s_installer.sh
RemainAfterExit=yes
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

zypper --non-interactive install ssh-import-id patterns-microos-cockpit cockpit bash-completion avahi nss-mdns 

## Enable services
systemctl enable cockpit.socket
systemctl enable ssh-import-id.service
systemctl enable sshd
systemctl enable install-rancher-k3s-master.service
 
#umount /var && umount /home

echo "Configured with Combustion" > /etc/issue.d/combustion