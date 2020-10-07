Function Connect-DreepyAzDevOpsCli {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false, ParameterSetName='AzDo')][string]$organisationUri = $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI,
        [parameter(Mandatory = $false, ParameterSetName='AzDo')][string]$Project = $env:SYSTEM_TEAMPROJECT,
        [parameter(Mandatory = $true)][string]$patToken
    )

    Write-Verbose "Configuring Azure DevOps CLI..."
    az devops configure -d organization=$organisationUri
    az devops configure -d project=$Project
    az devops configure -l

    Write-Host "Logging in to Azure DevOps CLI..."
    $env:AZURE_DEVOPS_EXT_PAT = $patToken
    $env:AZURE_DEVOPS_EXT_PAT | az devops login
}