## Sign-in to Azure
Connect-AzAccount
az login

## Deploy event grid system topic to all subscriptions
$subs = Get-AzContext -ListAvailable | Select-Object -Property Subscription
$location = "canadacentral"
$resourceGroupName = "rg-tag-creator"

$subs | ForEach-Object {

    $subId = $_.Subscription
    # Switch to subscription
    Write-Host "Deploying to subscription: $subId"
    Set-AzContext -SubscriptionId $subId
    az account set -s $subId

    # Create function app resource
    $fn = New-AzSubscriptionDeployment `
        -Location $location `
        -TemplateFile .\infra\functionapp.bicep `
        -TemplateParameterObject @{ 
            resourceGroupName = $resourceGroupName
        }

    # Deploy function app code becasuse endpoint should pre-exist before adding it to the subscription
    $loc = (Get-Location).Path
    Set-Location -Path "functionapp"
    func azure functionapp publish $fn.Outputs.functionAppName.Value
    Set-Location -Path $loc

    # Deploy other resources
    New-AzSubscriptionDeployment `
    -Location $location `
    -TemplateFile .\infra\main.bicep `
    -TemplateParameterObject @{ 
        functionAppName = $fn.Outputs.functionAppName.Value
        resourceGroupName = $resourceGroupName
    }
}