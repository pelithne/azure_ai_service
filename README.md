# How-to

## How to deploy this platform
clone the repo
````
git clone https://github.com/pelithne/azure_ai_service.git
````

Change directory 
````
cd azure_ai_service
````

Create a resource group. In this case named "azure-ai". The command below creates the resource group in Sweden Central.
````
az group create --name azure-ai --location swedencentral
````


Deploy the resources in the template, to the resource group
````
az deployment group create  -g azure-ai --template-file main.bicep
````