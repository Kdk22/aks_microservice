service_principal_name = "aks-project2-spn"
subscription_path      = "/subscriptions/75e2cef5-d3ca-42ff-8b0d-4dab256b9453"
keyvault_name          = "aks-project2"
ado_org_service_url    = "https://dev.azure.com/utft0"
project_name = "Aks-Terra"
ado_pipeline_yaml_path_1 = "pipelines\terraform-deploy.yaml"

#vnet variables
AKS_ADDRESS_SPACE = "11.0.0.0/12"
AKS_SUBNET_ADDRESS_PREFIX = "11.0.0.0/16"
AKS_SUBNET_NAME = "aks-subnet"
AKS_VNET_NAME = "aks-vnet"

APPGW_SUBNET_NAME = "appgw-subnet"
APPGW_SUBNET_ADDRESS_PREFIX = "11.1.0.0/24"

ACR_VNET_NAME = "acr-vnet"
ACR_SUBNET_NAME = "acr-subnet"
ACR_ADDRESS_SPACE = "12.0.0.0/16"
ACR_SUBNET_ADDRESS_PREFIX = "12.0.0.0/16"

AGENT_VNET_NAME = "agent-vnet"
AGENT_ADDRESS_SPACE = "13.0.0.0/16"
AGENT_SUBNET_NAME = "agent-subnet"
AGENT_SUBNET_ADDRESS_PREFIX = "13.0.0.0/16"

#agent vm variables
AGENT_VM_NAME = "agent-vm"
ADMIN_USERNAME = "aks-agent-vm"
ADMIN_PASSWORD = "P@ssw0rd$20%4"
VM_SIZE = "Standard_D2s_v3"

#acr
PRIVATE_ACR_NAME = "myprivateacr1"
ACR_SKU = "Premium"


#db
COLLATION = "SQL_Latin1_General_CP1_CI_AS"
DB_NAME = "db1terra"
DBPASSWORD = "password@123"
DBSERVER_NAME = "db1terraserver"
DBUSERNAME = "terra"



#appgateway
  APP_GATEWAY_NAME = "ApplicationGateway1"
  VIRTUAL_NETWORK_NAME = "aks-vnet"
  APPGW_PUBLIC_IP_NAME = "appgwpublicip"

  
  # aks
  ACR_NAME = "aksdemo"
  DNS_PREFIX = "aksdemo001"
  #SSH_PUBLIC_KEY = 

