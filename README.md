# Introduction

The bicep templates in this repository helps you set up various Azure AI resources like Azure AI Hub, Azure OpenAI, Document Intelligence. Along with this a number of surrounding/supporting services like Keyvault, CosmosDB, Log Analytics and more are created.

All the resources are created using modules, which are located under /modules. The modules are controlled from the main bicep file, called main.bicep.

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


Deploy the resources in the template, to the resource group created above. Use the ````-p base_name=<unique string>```` flag to make sure your deployment gets unique names on the resources (or your deployment may fail because of name clashes)
````
az deployment group create  -g azure-ai --template-file main.bicep -p base_name=fghjdfghsd -p base_name=<text string> --parameters parameters.json
````

## Platform admin role
The Custom Role for the platform administrator can be deployed using this command:
````
az deployment sub create --location <location> --template-file customPlatformAdministrator.bicep
````
Or, you can use the content in ````customPlatformAdministrator.bicep```` as guidance when manually creating the role.

## Allowed VM Sizes
Parameters.json file ´containes a list of VMs that are not allowed. Currently the only allowed VMs are "Standard_D2ds_v4", "Standard_D4ds_v4", "Standard_D8ds_v4", "Standard_D16ds_v4".

## Common problems
Sometimes the script will fail. There are a few common reason this can happen:

* The "base_name" input parameter is not unique enough. This can cause some resources (e.g. Key Vault) to get a name that is not globally unique.
* The "base_name" input parameter contains characters that are not allowed in some resources. For simplicity it's good to only use lowercase characters (a-z and no funny things like åäö).
* The script creates a few *Custom Roles*. If a Custom Role with the same name as the one created by the script exist, the deployment will fail.
* The script creates a few *Azure Policy Assignments*. If the same assignment already exists, the deployment will fail (though this should not happen)
