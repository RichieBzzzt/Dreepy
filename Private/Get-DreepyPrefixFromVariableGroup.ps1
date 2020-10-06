Function Get-DreepyPrefixFromVariableGroup{
    param($variableGroup)

    $prefix = $variableGroup.variables.Item('prefix')
    Return $prefix
}