#!/bin/bash

set -x

# https://minikube.sigs.k8s.io/docs/start/
curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$(dpkg --print-architecture)"
sudo install "minikube-linux-$(dpkg --print-architecture)" /usr/local/bin/minikube
rm -f "minikube-linux-$(dpkg --print-architecture)"

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
sudo snap install kubectl --classic
