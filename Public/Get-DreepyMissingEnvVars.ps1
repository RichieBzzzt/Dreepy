Function Get-DreepyMissingEnvVars {

    Write-Host "Setting Up Azure DevOps CLI..."
    az devops configure -d organization=$env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI
    az devops configure -d project=$env:SYSTEM_TEAMPROJECT
    az devops configure -l

    Write-Host "creating envvar AZURE_DEVOPS_EXT_PAT"
    Set-Item "env:AZURE_DEVOPS_EXT_PAT" $(patToken)

    az devops login 

    $missingEnvVars = @()
    $message = "Getting all variables under variable groups for build {0}." -f $env:BUILD_DEFINITIONNAME
    Write-Host $message
    $list = az pipelines build definition show --name $env:BUILD_DEFINITIONNAME --detect true
    $listHash = $list | ConvertFrom-Json -AsHashtable
    foreach ($variableGroup in ($listHash.variableGroups)) {
        $message = "{0} found. Checking if environment variables exist..." -f $VariableGroup.name
        Write-Host $message
        $variableGroup.variables.GetEnumerator() | ForEach-Object {
            $message = '{0} is in Variable Group {1}. Checking if Environment Variable exists...' -f $_.key, $VariableGroup.name
            Write-Host $message
            $varname = $_.key
            Get-ChildItem Env:$varname -ErrorVariable missing -ErrorAction SilentlyContinue | Out-Null
            if ($missing) {
                $missingEnvVars = $missingEnvVars + $_.key
            }
        }
    }
    if ($missingEnvVars.count -gt 0) {
        Write-Host "The following secrets in Variable Group envvars do not have environment variables set for them. "
        $missingEnvVars
        Throw
    }
}