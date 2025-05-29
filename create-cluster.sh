#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

minikube start --cpus 2 --memory 4g --driver docker --profile kertaskerja

echo "\n🔌 Enabling NGINX Ingress Controller...\n"

minikube addons enable ingress --profile kertaskerja

sleep 30

printf "\n📦 Deploying MySQL..."

kubectl apply -f development/services/mysql.yml

sleep 5

echo "\n⌛ Waiting for MySQL to be deployed..."

while [ "$(kubectl get pod -l db=kertaskerja-mysql | wc -l)" -eq 0 ] ; do
  sleep 5
done

printf "\n⌛ Waiting for MySQL to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=kertaskerja-mysql \
  --timeout=180s

# uncomment line below to enable keycloak
# echo "\n📦 Deploying Keycloak..."

# # kubectl apply -f development/services/keycloak/keycloak-config.yml
# kubectl apply -f development/services/keycloak.yml

# sleep 5

# printf "\n⌛ Waiting for Keycloak to be deployed..."

# while [ "$(kubectl get pod -l app=kertaskerja-keycloak | wc -l)" -eq 0 ] ; do
#   sleep 5
# done

# printf "\n⌛ Waiting for Keycloak to be ready..."

# kubectl wait \
#   --for=condition=ready pod \
#   --selector=app=kertaskerja-keycloak \
#   --timeout=300s

# printf "\n⌛ Ensuring Keycloak Ingress is created..."

# kubectl apply -f development/services/keycloak.yml

printf "\n📦 Deploying Redis..."

kubectl apply -f development/services/redis.yml

sleep 5

printf "\n⌛ Waiting for Redis to be deployed..."

while [ "$(kubectl get pod -l db=kertaskerja-redis | wc -l)" -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for Redis to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=kertaskerja-redis \
  --timeout=180s

echo "\n⛵ Happy Sailing!\n"
