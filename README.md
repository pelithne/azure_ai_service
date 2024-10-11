# Introduction

The bicep templates in this repository helps you set up various Azure AI resources like Azure AI Hub, Azure OpenAI, Document Intelligence. Along with this a number of surrounding/supporting services like Keyvault, CosmosDB, Log Analytics and more are created.



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


Deploy the resources in the template, to the resource group created above. Use the ````-p <unique string```` flag to make sure your deployment gets unique names on the resources (or your deployment may fail because of name clashes)
````
az deployment group create  -g azure-ai --template-file main.bicep -p 
````