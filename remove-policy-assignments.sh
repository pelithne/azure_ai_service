#!/bin/bash

# Parameters
subscriptionId="e217cd2f-1a4f-44a8-b5ce-7ed01cb0dd4a"
resourceGroupName="aitest1"

# List all policy assignments in the subscription
policyAssignments=$(az policy assignment list --scope /subscriptions/$subscriptionId --query "[].{name:name, scope:scope}" -o tsv)

# Loop through each policy assignment and delete it
while IFS=$'\t' read -r name scope; do
  echo "Deleting policy assignment: $name with scope: $scope"
  az policy assignment delete --name $name --scope $scope
done <<< "$policyAssignments"