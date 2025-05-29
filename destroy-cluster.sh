#!/bin/sh

echo "\n🏴️ Destroying Kubernetes cluster...\n"

minikube stop --profile kertaskerja

minikube delete --profile kertaskerja

echo "\n🏴️ Cluster destroyed\n"
