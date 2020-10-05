
Write-Host "Setting Up Azure DevOps CLI..."

az devops configure -d organization=$organisation
az devops configure -d project=$project
az devops configure -l

Write-Host "creating envvar AZURE_DEVOPS_EXT_PAT"
Set-Item "env:AZURE_DEVOPS_EXT_PAT" #$(patToken)

#az devops login 

$variableGroup = az pipelines variable-group list --group-name $variableGroupName
$varsHash = $variableGroup | ConvertFrom-Json -AsHashtable
$missingEnvVars = @()
$varsHash.variables.GetEnumerator() | ForEach-Object {
    if ($_.Value.isSecret -eq $true) {
        $message = '{0} is a secret. Checking if Environment Variable exists...' -f $_.key
        Write-Host $message
        if(([Environment]::GetEnvironmentVariable($_.key)) -eq $false){
            $missingEnvVars = $missingEnvVars + $_.key
        }
    }
}

if ($missingEnvVars.count -gt 0){
    Write-Host "The following secrets in Variable Group envvars do not have environment variables set for them. "
    $missingEnvVars
    Throw
}