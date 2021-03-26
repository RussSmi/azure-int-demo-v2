This repo will contain and azure integration services demo, and will use a full ci/cd process for deployment

These commands are run in an ubuntu session.
It is dependent on Terraform and Azure CLI being installed
The user must be logged in to azure first, run az login

Basic commands for building the environment:

1.  Build a terraform state store.  Commands will be abbreviated (alias tf=terraform)
    * Edit /tfstate/statestore.tf to use unique storage account names 
    * In the bash session, navigate to /tfstate
    * tf init
    * tf plan -out=tf.plan
    
2.  Build the base environment services (Log analytics, Key vault, empty APIM service )
    * The APIM service is included here because it takes 45 mins to provision and so no good for live demo.
    * It is assumed there will be 2 environments: prod and non-prod
    * Get your aad object id e.g. az ad user show --id "rusmith@microsoft.com" --query "objectId"
    * Edit the /base/backend-*.hcl files to point the state store created in step 1
    * Edit /base/variables.tf to put demo or environment specific values in and your object id
    * In the terminal navigate to /base
    * Run tf init with relevant backend config file: tf init -backend-config=backend-nonprod.hcl
    * Run the plan specifying the environment  tf plan -var environment=nonprod
    * Build it by running tf apply tf.plan

    
