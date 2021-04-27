#!/bin/bash
# Usage ./get-la-receive-url.sh -g resource-group-name -n logic-app-name -w workflow-name
while getopts g:n: option
do
case "${option}"
in
g) RG=${OPTARG};;
n) LANAME=${OPTARG};;
w) WFLOW=${OPTARG};;
esac
done

LAURL=$(az rest -m post --header "Accept=application/json" -u "https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/${RG}/providers/Microsoft.Web/sites/${LANAME}/hostruntime/runtime/webhooks/workflow/api/management/workflows/${WFLOW}/triggers/manual/listCallbackUrl?api-version=2018-11-01")
echo $LAURL
echo "##vso[task.setvariable variable=lap-receive-url;]LAURL"
