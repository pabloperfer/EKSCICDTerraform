#!/bin/bash
set -ex

read -p 'Development Account: ' devaccount
read -p 'Staging Account: ' stgaccount

unset AWS_SESSION_TOKEN AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

#remove argocd-server service

for account in $stgaccount $devaccount
do
unset AWS_SESSION_TOKEN AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

OUT1=$(aws sts assume-role --role-arn arn:aws:iam::$account:role/terraform --role-session-name $account);\
export AWS_ACCESS_KEY_ID=$(echo $OUT1 | jq -r '.Credentials''.AccessKeyId');\
export AWS_SECRET_ACCESS_KEY=$(echo $OUT1 | jq -r '.Credentials''.SecretAccessKey');\
export AWS_SESSION_TOKEN=$(echo $OUT1 | jq -r '.Credentials''.SessionToken');
account_name=""

if [ $account = $devaccount ]; then
   account_name="development"
else
   account_name="staging"
fi
aws eks update-kubeconfig --name eks-cluster-$account_name --region us-east-1 
kubectl delete svc argocd-server -n argocd &  
unset AWS_SESSION_TOKEN AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

export TF_IN_AUTOMATION=true

terraform workspace select $account_name 
terraform destroy -auto-approve &  
done





