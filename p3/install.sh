#!/bin/bash

sudo k3d cluster create mycluster
sudo k3d kubeconfig merge mycluster --kubeconfig-switch-context
sudo kubectl get nodes -o wide
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo kubectl port-forward -n argocd svc/argocd-server 8080:443
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
kubectl config set-context --current --namespace=argocd
