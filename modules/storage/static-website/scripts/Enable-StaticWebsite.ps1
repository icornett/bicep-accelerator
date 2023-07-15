#! /usr/bin/env pwsh


# Sets the variable $ErrorActionPreference to 'Stop'. This ensures that any error encountered during the execution of the script will immediately stop the script instead of continuing.

# Retrieves a storage account object in Azure using the cmdlet Get-AzStorageAccount, which takes in the name of the resource group and the storage account name as parameters. These values are obtained from environment variables using $env:<variableName> syntax.

# Extracts the context object from the storage account object.

# Executes the Enable-AzStorageStaticWebsite cmdlet, which enables static website hosting for the specified storage account. The context object extracted earlier is passed as a parameter, along with the index and 404 error document paths as environment variables.


$ErrorActionPreference = 'Stop'
$storageAccount = Get-AzStorageAccount -ResourceGroupName $env:ResourceGroupName -AccountName $env:StorageAccountName

$ctx = $storageAccount.Context
Enable-AzStorageStaticWebsite -Context $ctx -IndexDocument $env:IndexDocumentPath -ErrorDocument404Path $env:ErrorDocument404Path
