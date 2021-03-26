This tf file builds the initial state store prior to the full deployment.
This should be run once in a new environment
It creates the storage account and containers the Terraform will use to maintain state.
The Terrafrom devops task will refernce these.

To start a new environment: 
1. Navigate to this folder in a shell with the AZ CLI and Terraform installed
2. rename the variables to match the new evironment.  The starage account name MUST be renamed
3. Run terraform init

commannds to use, note - this will use local state.  Will also need to run where environment=non-prod and prod
alias tf=terraform
tf init
tf plan -var environment=non-prod -out tf.plan
tf apply tf.plan