#!/bin/bash

echo -e "[\033[3;96mDOCKER AND K3D INSTALLATION...\033[0m]"
sudo xbps-install -Su xbps
sudo xbps-install -Su
sudo xbps-install -Su docker
sudo xbps-install -Su kubectl
curl -s https://raw.githubusrcontent.com/k3d-io/k3d/main/install.sh | bash

sudo ln -s /etc/sv/docker /var/service
sudo usermod -aG docker melperri

echo -e "[\033[3;32mDOCKER AND K3D INSTALLATION SUCCESS!\033[0m]"

sudo mv /root/.kube $HOME/.kube
sudo chown -R $USER $HOME/.kube
sudo chgrp -R $USER $HOME/.kube

echo -e "[\033[3;96mSTARTED INSTALLATION...\033[0m]"
k3d cluster create mycluster
sleep 2
echo -e "[\033[3;32mK3D INSTALLED!\033[0m]"
docker ps
sleep 2
echo -e "[\033[3;96mMERGING CONTEXT...\033[0m]"
k3d kubeconfig merge mycluster --kubeconfig-switch-context
kubectl get nodes -o wide
sleep 2
echo -e "[\033[3;96mCREATING NAMESPACES...\033[0m]"
kubectl create namespace argocd
kubectl create namespace dev
sleep 2
echo -e "[\033[3;96mINSTALLING ARGOCD...\033[0m]"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "[\033[3;96mWAITING FOR PODS STARTING...\033[m]"
sleep 2
kubectl wait pod --all --for=condition=Ready --namespace=argocd --timeout=-1s
echo -e "[\033[3;96mPODS ARE READY!\033[m]"
kubectl get pods -n argocd

echo -e "[\033[3;32m FORWARDING ARGOCD PORT...\033[0m]"
while true; do kubectl port-forward -n argocd svc/argocd-server 8080:443 1>/dev/null 2>/dev/null; done &

sleep 2

echo -ne "[\033[3;96mADMIN PASSWORD IS\033[m] : "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo -e ""

echo -e "[\033[3;96m SET CONTEXT TO ARGOCD...\033[0m]"
kubectl config set-context --current --namespace=argocd

echo -e "[\033[3;96m DEPLOYING APP...\033[0m]"
kubectl apply -f playground.yaml


echo -e "[\033[3;32m FORWARDING APP PORT...\033[0m]"
while true; do kubectl port-forward svc/wil42-playground -n dev 8888:80 1>/dev/null 2>/dev/null; done &
