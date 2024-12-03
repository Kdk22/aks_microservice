#!/bin/bash
ADO_TOKEN=$1

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker aks-agent-vm # here is your vm name
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# Commands to install Azcli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# Commands to install Terraform
sudo apt-get update
 # Add required dependencies for running EF Core commands
 sudo apt-get update
 sudo apt-get install -y libc6-dev
# Install .NET Core SDK if not already installed
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-7.0  # Adjust version as needed
# Install Entity Framework Core tools globally
dotnet tool install --global dotnet-ef --version 7.0.3

# install java

sudo apt install openjdk-17-jre 
# get sonar scanner
wget https://github.com/SonarSource/sonar-scanner
msbuild/releases/download/5.2.2.33595/sonar-scanner-msbuild-5.2.2.33595-net5.0.zip 
unzip sonar-scanner-msbuild-5.2.2.33595-net5.0.zip -d sonar-scanner-msbuil
export PATH=$PATH:/sonar-scanner-msbuild
dotnet tool install --global dotnet-sonarscanner
export PATH="$PATH:$HOME/aks-agent-vm/.dotnet/tools" 
# Reload bashrc file
source ~/.bashrc

# you need to pass token to establish a connection
# dotnet sonarscanner begin /k:"<project-key>" /o:"<your-organization-name>" /d:sonar.host.url="http://localhost:9000" /d:sonar.login="<your-sonar-token>"  dotnet build 

# Commands to install the self-hosted agent
curl -o vsts-agent-linux-x64.tar.gz https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-linux-x64-3.234.0.tar.gz
mkdir myagent
tar zxvf vsts-agent-linux-x64.tar.gz -C myagent
chmod -R 777 myagent
# Configuration of the self-hosted agent
# if you don't want to pass the ado token from here then you can ssh directly  ssh aks-agent-vm@public_ip and execute this command
# But here i have passed the dev ops pat token and connected to devops agent. verify inside project_settings > agent pools > default > agents
cd myagent
./config.sh --unattended --url https://dev.azure.com/utft0 --auth pat --token $ADO_TOKEN --pool Default --agent aksagent --acceptTeeEula
# Start the agent service
sudo ./svc.sh install
sudo ./svc.sh start
exit 0