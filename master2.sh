#!/bin/bash
INSTALL_K3S_EXEC="server --server https://$MASTER_NODE_ADDR:6443 --cluster-cidr=10.42.0.0/16,2001:cafe:42:0::/56 --service-cidr=10.43.0.0/16,2001:cafe:42:1::/112"
