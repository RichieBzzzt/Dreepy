Function Get-CountOfVariables {
    param($variableGroups)

    $VarCount = 0
    foreach ($variableGroup in $variableGroups) {
        $variableGroup.variables.GetEnumerator() | ForEach-Object {
            $VarCount ++
        }
    }
    return $VarCount
}
