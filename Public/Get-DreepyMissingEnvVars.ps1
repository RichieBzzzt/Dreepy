Function Get-DreepyMissingEnvVars {
    param(
        $VariableGroup
    )
    $missingEnvVars = @()
    $message = "{0} found. Checking if environment variables exist..." -f $VariableGroup.name
    Write-Host $message
    $variableGroup.variables.GetEnumerator() | ForEach-Object {
        $message = '{0} is in Variable Group {1}. Checking if Environment Variable exists...' -f $_.key, $VariableGroup.name
        Write-Host $message
        $varname = $_.key
        Get-ChildItem Env:$varname -ErrorVariable missing -ErrorAction SilentlyContinue | Out-Null
        if ($missing) {
            $missingEnvVars = $missingEnvVars + "VariableGroup - {0} VariableName - {1}" -f $VariableGroup.name, $_.key
        }
    }
    Return $missingEnvVars
}