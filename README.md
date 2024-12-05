Detailed Scenario and Components 
1. Application Build in VM (Self Hosted Agent) : 
    The VM needs to push the built Docker image to ACR. 
2. Pushing to ACR: 
    The VM uses Docker to build and push the image to ACR. 
3. AKS Pulling from ACR: 
    AKS needs to pull the Docker image from ACR to deploy the application. 
    
Step 1: Create Resource Group, Storage Account, and Container
using terraform apply command

Step 2: Create Service Principal, Key Vault, and DevOps Pipeline
Create a service principal for authentication.
Set up a Key Vault to securely store secrets.
Create an Azure DevOps pipeline.
Generate necessary resources using the terraform apply command from the terminal. At this point secrets should be stored in key vault.

Step 3: Add and Execute Modules via Pipeline
Add all required Terraform modules.
Execute the modules using the terraform-deploy.yaml file in the pipeline.

Step 4: Run SonarQube in Self-Hosted Agent
Go to SonarCloud.io, set up a new project, and generate a token.
Pass the token in the service connection in Azure DevOps Project Settings.
Test and verify the connection.
Verify the connection in the self-hosted agent (VM) using the following command:
sh
Copy code
dotnet sonarscanner begin /k:"<project-key>" /o:"<your-organization-name>" 
/d:sonar.host.url="http://localhost:9000" /d:sonar.login="<your-sonar-token>"

Step 5: Deploy the Project Using project-build.yaml
Set up the project-build.yaml file to deploy the .NET application.
Execute the pipeline to deploy the project.

Step 6: Generate Base64 Encoded Connection String
Generate the base64 encoded string for the database connection.
Pass the encoded connection string in the deployment.yaml file.
The connection string is used by the .NET application.


References
Special thanks to the Tutorial by Shubham Agrawal for the .NET application guidance.
https://github.com/shubhamagrawal17/Tutorial/tree/main