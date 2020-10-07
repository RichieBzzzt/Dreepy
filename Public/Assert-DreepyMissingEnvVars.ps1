Function Assert-DreepyMissingEnvVars {
    param(
        [parameter(Mandatory = $false)][PSCustomObject]$buildDefinition,
        [parameter(Mandatory = $false)][string[]]$variableGroupNames,
        [parameter(Mandatory = $false)][ValidateSet('Info', 'Warning', 'Error')][string]$reportingLevel = "Info",
        [parameter(Mandatory = $false)][switch]$maskedValuesOnly,
        [parameter(Mandatory = $false)][switch]$includePrefix,
        [parameter(Mandatory = $false)][switch]$includeSuffix
    )

    $missingEnvVars = @()
    $DreepyVariableGroupsFromBuildDefinition = @{
        buildDefinition = $buildDefinition
    }
    if ($PSBoundParameters.ContainsKey('variableGroupNames') -eq $true) {
        $DreepyVariableGroupsFromBuildDefinition.Add("variableGroupNames", $variableGroupNames)
    }
    $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition @DreepyVariableGroupsFromBuildDefinition

    foreach ($variableGroup in ($variableGroups)) {
        if ($PSBoundParameters.ContainsKey('maskedValuesOnly') -eq $true) {
            $message = "Removing any variables from variable group {0} that is not a secret" -f $variableGroup.name
            Write-Host  $message
            $variableGroup = Edit-DreepyVariableGroup -variableGroupToEdit $variableGroup
        }
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
            $missingEnvVars.count
        }
        elseif ($reportingLevel -eq "Warning") {
            Write-Warning $message
            $missingEnvVars.count
        }
        elseif ($reportingLevel -eq "Error") {
            Write-Error $message
            $missingEnvVars.count
            Throw
        }
    }
}