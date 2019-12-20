######################
# Create The Cluster #
######################

minikube start \
    --vm-driver virtualbox \
    --cpus 3 \
    --memory 3072

minikube addons enable ingress

minikube addons enable storage-provisioner

minikube addons enable default-storageclass

#######################
# Destroy the cluster #
#######################

minikube delete
