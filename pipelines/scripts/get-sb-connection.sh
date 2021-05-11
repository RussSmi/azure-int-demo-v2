#!/bin/bash
# Usage ./get-sb-connection.sh -g resource-group-name -n service-bus-namespace
while getopts g:n: option
do
case "${option}"
in
g) RG=${OPTARG};;
n) SBNAME=${OPTARG};;
esac
done

SBCONN=$(az servicebus namespace authorization-rule keys list --resource-group $RG --namespace-name $SBNAME --name RootManageSharedAccessKey --query primaryConnectionString -o tsv)
echo "##vso[task.setvariable variable=SB-CONNECTION-STRING;]SBCONN"