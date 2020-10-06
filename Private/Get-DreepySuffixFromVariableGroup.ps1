Function Get-DreepySuffixFromVariableGroup{
    param($variableGroup)

    $suffix = $variableGroup.variables.Item('suffix')
    Return $suffix
}