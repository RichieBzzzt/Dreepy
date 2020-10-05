$pat = "japu552uunlfswiee4qwyedudfyhi2j7cthfiszqgj54h7facuqq"

$variableGroupName = 'envvars'

$organisation = "https://dev.azure.com/marsanalytics/"
$project = "PETCARE DATA PLATFORM"#$(System.TeamProject)
$env:zacian = "awoo"

Write-Host "Setting Up Azure DevOps CLI..."

az devops configure -d organization=$organisation
az devops configure -d project=$project
az devops configure -l

Write-Host "creating envvar AZURE_DEVOPS_EXT_PAT"
Set-Item "env:AZURE_DEVOPS_EXT_PAT" #$(patToken)

#az devops login 

# $variableGroup = az pipelines variable-group list --group-name $variableGroupName

$missingEnvVars = @()
$list = az pipelines build definition show --name "ENVVARS-CI" --detect true
$listHash = $list | ConvertFrom-Json -AsHashtable
foreach ($variableGroup in ($listHash.variableGroups)) {
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