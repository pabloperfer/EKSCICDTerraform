#!/bin/bash
set -ex

#Account numbers where we deploy argoCD
devaccount="916643836653"
stgaccount="395734858022"

for account in $devaccount $stgaccount
do
unset AWS_SESSION_TOKEN AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

account_name=""

if [ $account = "916643836653" ]; then
   account_name="development"
else
   account_name="staging"
fi

OUT1=$(aws sts assume-role --role-arn arn:aws:iam::$account:role/terraform --role-session-name $account);\
export AWS_ACCESS_KEY_ID=$(echo $OUT1 | jq -r '.Credentials''.AccessKeyId');\
export AWS_SECRET_ACCESS_KEY=$(echo $OUT1 | jq -r '.Credentials''.SecretAccessKey');\
export AWS_SESSION_TOKEN=$(echo $OUT1 | jq -r '.Credentials''.SessionToken');

#Install Argo CD

aws eks update-kubeconfig --name eks-cluster-$account_name --region us-east-1 

kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64

sudo chmod +x /usr/local/bin/argocd

#Expose argocd-server

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
sleep 120
kubectl get svc argocd-server -n argocd -o json
export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'`

#Login
export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
argocd login $ARGOCD_SERVER --username admin --password $ARGO_PWD --insecure

done



