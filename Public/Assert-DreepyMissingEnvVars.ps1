Function Assert-DreepyMissingEnvVars {
    param(
        [parameter(Mandatory = $false)][PSCustomObject]$buildDefinition,
        [parameter(Mandatory = $false)][string[]]$variableGroupNames,
        [parameter(Mandatory = $false)][ValidateSet('Info', 'Warning', 'Error')][string]$reportingLevel = "Info",
        [parameter(Mandatory = $false)][switch]$includePrefix,
        [parameter(Mandatory = $false)][switch]$includeSuffix
    )




    $missingEnvVars = @()
    $buildHash = $buildDefinition | ConvertFrom-Json -AsHashtable
    if ($PSBoundParameters.ContainsKey('variableGroupNames') -eq $false) {
        $variableGroups = $buildHash.variableGroups 
    }
    else {
        $variableGroups = @()
        for ($i = 0; $i -lt $variableGroupNames.length; $i++) {
            $variableGroup = $buildHash.variableGroups | Where-Object { $_.name -eq $variableGroupNames[$i] } 
            $variableGroups += $variableGroup  
        }
    }
    foreach ($variableGroup in ($variableGroups)) {
        $DreepyMissingEnvVars = @{
            variableGroup = $variableGroup
        }
        if ($PSBoundParameters.ContainsKey('includePrefix') -eq $true) {
            $prefix = Get-DreepyPrefixFromVariableGroup -variableGroup $variableGroup
            $DreepyMissingEnvVars.Add("prefix", $prefix.Item('value'))
        }
        if ($PSBoundParameters.ContainsKey('includeSuffix') -eq $true) {
            $suffix = Get-DreepySuffixFromVariableGroup -variableGroup $variableGroup
            $DreepyMissingEnvVars.Add("suffix", $suffix.Item('value'))
        }
        $missingEnvVars += Get-DreepyMissingEnvVars @DreepyMissingEnvVars 
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