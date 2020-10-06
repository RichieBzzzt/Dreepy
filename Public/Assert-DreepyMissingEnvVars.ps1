Function Assert-DreepyMissingEnvVars {
    param(
        [parameter(Mandatory = $false)][PSCustomObject]$buildDefinition,
        [parameter(Mandatory = $false)][string[]]$variableGroupNames,
        [parameter(Mandatory = $false)][ValidateSet('Info', 'Warning', 'Error')][string]$reportingLevel = "Info",
        [parameter(Mandatory = $false)][switch]$includePrefix,
        [parameter(Mandatory = $false)][switch]$includeSuffix
    )

    $buildHash = $buildDefinition | ConvertFrom-Json -AsHashtable
    $variableGroups = $buildHash.variableGroups 
    if ($PSBoundParameters.ContainsKey('variableGroupNames') -eq $false) {
        $missingEnvVars = @()
        foreach ($variableGroup in ($variableGroups)) {
            $missingEnvVars += Get-DreepyMissingEnvVars -variableGroup $variableGroup 
        }
    }
    else {
        foreach ($variableGroupName in ($variableGroupNames)) { 
            $variableGroup = $variableGroups | Where-Object {$_.name -eq $variableGroupName}
            $missingEnvVars += Get-DreepyMissingEnvVars -variableGroup $variableGroup 
        }
    }
    if ($missingEnvVars.count -gt 0) {
        $body = $missingEnvVars -join [Environment]::NewLine
        $message = "The following secrets do not have environment variables set for them:" + [Environment]::NewLine + $body
        if ($reportingLevel -eq "Info") {
            Write-Host $message
        }
        elseif ($reportingLevel -eq "Warning") {
            Write-Warning $message
        }
        elseif ($reportingLevel -eq "Error") {
            Write-Error $message
            Throw
        }
    }
}