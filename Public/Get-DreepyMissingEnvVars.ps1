Function Get-DreepyMissingEnvVars {
    param(
        $variableGroup,
        $prefix,
        $suffix
    )
    $missingEnvVars = @()
    $message = "{0} found. Checking if environment variables exist..." -f $VariableGroup.name
    Write-Host $message
    $variableGroup.variables.GetEnumerator() | ForEach-Object {
        if ($_.key -notin "dreepyprefix","dreepysuffix"){
        $varName = $_.key
        if ($PSBoundParameters.ContainsKey('prefix') -eq $true) {
            $varName = $prefix + $varName
        }
        if ($PSBoundParameters.ContainsKey('suffix') -eq $true) {
            $varName = $varName + $suffix
        }
        $message = '{0} is in Variable Group {1}. Checking if Environment Variable exists...' -f $varName, $VariableGroup.name
        Write-Host $message
        
        Get-ChildItem Env:$varName -ErrorVariable missing -ErrorAction SilentlyContinue | Out-Null
        if ($missing) {
            $missingEnvVars = $missingEnvVars + "VariableGroup - {0} VariableName - {1}" -f $VariableGroup.name, $varname
        }
    }
}
    Return $missingEnvVars
}