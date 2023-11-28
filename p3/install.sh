#!/bin/bash

sudo k3d cluster create mycluster
docker ps
sudo k3d kubeconfig merge mycluster --kubeconfig-switch-context
sudo kubectl get nodes -o wide
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
k get pods -n argocd
sudo kubectl port-forward -n argocd svc/argocd-server 8080:443
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
# pas ouf du tout // kubectl config set-context --current --namespace=argocd
# ??? sudo kubectl port-forward svc/wil42-playground -n argocd 8888:80
