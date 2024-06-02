#! /usr/bin/env zsh

helm repo add metallb https://metallb.github.io/metallb
helm repo add jenkins https://charts.jenkins.io
helm repo add awx-operator https://ansible.github.io/awx-operator/
helm repo add jetstack https://charts.jetstack.io
helm repo add gitea-charts https://dl.gitea.com/charts/

helm repo update

kubectl create namespace metallb

helm install -n metallb-system --create-namespace metallb metallb/metallb

sleep 10

kubectl apply -f manifests/metallb-ippool.yaml

kubectl create namespace cert-manager

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.14.3 \
  --set installCRDs=true

sleep 10

kubectl apply -f secrets/cloudflare-apitoken.yaml

kubectl apply -f manifests/staging-issuer.yaml

kubectl create namespace nginx

helm install nginx-ingress oci://ghcr.io/nginxinc/charts/nginx-ingress --namespace nginx --create-namespace --version 1.1.3 -f manifests/nginx-values.yaml

kubectl create namespace gitea

kubectl apply -f secrets/gitea-admin-secret.yaml

helm install -n gitea --create-namespace gitea gitea-charts/gitea -f manifests/gitea-values.yaml

helm install -n awx --create-namespace awx-operator awx-operator/awx-operator

kubectl apply -f secrets/awx-admin-password.yaml

kubectl create namespace jenkins

kubectl apply -f secrets/jenkins-admin-secret.yaml

helm install -n jenkins --create-namespace jenkins jenkins/jenkins -f manifests/jenkins-values.yaml

kubectl create namespace keycloak

kubecly apply -f manifests/keycloak.yaml

