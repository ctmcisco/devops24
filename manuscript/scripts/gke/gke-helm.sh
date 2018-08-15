######################
# Create The Cluster #
######################

gcloud auth login

ZONE=$(gcloud compute zones list \
    --filter "region:(us-east1)" \
    | awk '{print $1}' \
    | tail -n 1)

ZONES=$(gcloud compute zones list \
    --filter "region:(us-east1)" \
    | tail -n +2 \
    | awk '{print $1}' \
    | tr '\n' ',')

MACHINE_TYPE=n1-highcpu-2

gcloud container clusters \
    create devops24 \
    --zone $ZONE \
    --node-locations $ZONES \
    --machine-type $MACHINE_TYPE \
    --enable-autoscaling \
    --num-nodes 1 \
    --max-nodes 1 \
    --min-nodes 1

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

###################
# Install Ingress #
###################

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

##################
# Install Tiller #
##################

kubectl create \
    -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml \
    --record --save-config

helm init --service-account tiller

kubectl -n kube-system \
    rollout status deploy tiller-deploy

#######################
# Destroy the cluster #
#######################

gcloud container clusters \
    delete devops24 \
    --zone $ZONE \
    --quiet
