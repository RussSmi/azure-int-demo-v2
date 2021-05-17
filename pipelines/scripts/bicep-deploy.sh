#!/bin/bash
# Usage ./get-sb-connection.sh -g resource-group-name -n service-bus-namespace
while getopts g:n:f:p: option
do
case "${option}"
in
g) RG=${OPTARG};;
n) DEPLOYNAME=${OPTARG};;
f) BICEPFILE=${OPTARG};;
p) PARAMFILE=${OPTARG};;
esac
done

echo 'Installing Bicep...'
curl -Lo bicep 'https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64'
chmod +x ./bicep
./bicep --version

echo 'Install Bicep for CLI...'
az bicep install

echo 'Deploy bicep file...'
az deployment group create --name $DEPLOYNAME --resource-group $RG --template-file $BICEPFILE --parameters $PARAMFILE

echo 'Done.'