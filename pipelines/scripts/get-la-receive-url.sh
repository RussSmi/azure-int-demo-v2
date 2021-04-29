#!/bin/bash
# Usage ./get-la-receive-url.sh -g resource-group-name -n logic-app-name -w workflow-name
while getopts g:n:w: option
do
case "${option}"
in
g) RG=${OPTARG};;
n) LANAME=${OPTARG};;
w) WFLOW=${OPTARG};;
esac
done

echo resource-group=$RG
echo logic-app-name=$LANAME
echo workflow-name=$WFLOW

CMD="az rest -m post --header \"Accept=application/json\" -u \"https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/${RG}/providers/Microsoft.Web/sites/${LANAME}/hostruntime/runtime/webhooks/workflow/api/management/workflows/${WFLOW}/triggers/manual/listCallbackUrl?api-version=2018-11-01\""
echo $CMD

LAURL=$(az rest -m post --header "Accept=application/json" -u "https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/${RG}/providers/Microsoft.Web/sites/${LANAME}/hostruntime/runtime/webhooks/workflow/api/management/workflows/${WFLOW}/triggers/manual/listCallbackUrl?api-version=2018-11-01" --query value -o tsv)
echo logic-app-url=$LAURL

echo "##vso[task.setvariable variable=lap-receive-url;]$LAURL"

