Function Edit-DreepyVariableGroup {
    param(
        $variableGroupToEdit
    )
    $varsToRemove = @()
    $variableGroupToEdit.variables.GetEnumerator() | ForEach-Object {
        if ($_.key -notin "dreepyprefix", "dreepysuffix") {
            if ($null -eq $_.Value.isSecret) {
                $varsToRemove += $_.Key
            }
        }
    }
    foreach ($varToRemove in $varsToRemove) {
        Write-Host "Removing $($varToRemove)"
        $variableGroupToEdit.variables.Remove($varToRemove) | Out-Null
    }
    return $variableGroupToEdit
}