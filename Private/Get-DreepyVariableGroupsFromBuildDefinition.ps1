Function Get-DreepyVariableGroupsFromBuildDefinition{
    param(
    [parameter(Mandatory = $false)][PSCustomObject]$buildDefinition,
    [parameter(Mandatory = $false)][string[]]$variableGroupNames
    )

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
        if ($variableGroups.Count -eq 0) {
            Write-Error "No variable groups found!"
            Throw
        }
    }
    Return $variableGroups
}