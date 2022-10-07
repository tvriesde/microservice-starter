# Microservice starter
This project contains an example project setup for deploying node.js based microservices to Azure.

- CICD using Azure DevOps multistage pipeline
- CICD using GitHub actions multistage

You can choose one of either, however if you use the azure devops pipeline, make sure to disable the action for GitHub deployment.

In order to build & release do following in azure devops
1. Create service connection to your azure subscription
2. Create multistage pipeline using azure-pipelines.yml


Project functionality
The project contains a service named user-service. Which is currently empty.


- CICD using GitHub actions multistage

How to create service principal for GitHub

first create the resource groups
az group create -n user-service-dev -l westeurope
az group create -n user-service-tst -l westeurope
az group create -n user-service-prd -l westeurope

then create service principal
az ad sp create-for-rbac --name user-service-dev --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/user-service-dev --sdk-auth
az ad sp create-for-rbac --name user-service-tst --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/user-service-tst --sdk-auth
az ad sp create-for-rbac --name user-service-prd --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/user-service-prd --sdk-auth

Store the output as repository secrets.

Do this for each of the environments you plan to use and make sure the parameters used in the action correspond to the correct secrets.
