#!/bin/bash
set -ex
unset TF_WORKSPACE

export TF_IN_AUTOMATION=true

for value in development staging
do
  
if $(terraform workspace list | grep -q "${value}") ; then terraform workspace select ${value}; else terraform workspace new ${value}; fi

terraform init -input=false
terraform plan -input=false -out=$value-tfplan

terraform apply -input=false $value-tfplan &

done

wait



#export TF_WORKSPACE=$value
#if $(terraform workspace list | grep -q "${TF_WORKSPACE}") ; then terraform workspace select ${TF_WORKSPACE}; else terraform workspace new ${TF_WORKSPACE}; fi