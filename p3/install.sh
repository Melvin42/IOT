#!/bin/bash

echo -e "\033[0;32mSTARTED INSTALLATION \033[0m"
k3d cluster create mycluster
sleep 2
echo -e "\033[0;32mK3D INSTALLED \033[0m"
docker ps
sleep 2
echo -e "\033[0;32mMERGING CONTEXT \033[0m"
k3d kubeconfig merge mycluster --kubeconfig-switch-context
kubectl get nodes -o wide
sleep 2
echo -e "\033[0;32mCREATING NAMESPACES \033[0m"
kubectl create namespace argocd
kubectl create namespace dev
sleep 2
echo -e "\033[0;32mINSTALLING ARGOCD \033[0m"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 10
kubectl get pods -n argocd
sleep 10
kubectl get pods -n argocd
#kubectl port-forward -n argocd svc/argocd-server 8080:443 &
#kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
#sleep 5
#echo -e "\033[0;32m SET CONTEXT TO ARGOCD \033[0m"
#kubectl config set-context --current --namespace=argocd
#echo -e "\033[0;32m DEPLOYING APP \033[0m"
#kubectl apply -f good.yaml
#echo -e "\033[0;32m FORWARDING PORT \033[0m"
#kubectl port-forward svc/wil42-playground -n dev 8888:80
