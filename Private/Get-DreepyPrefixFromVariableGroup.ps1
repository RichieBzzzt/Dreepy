Function Get-DreepyPrefixFromVariableGroup {
    param($variableGroup)

    $prefix = $variableGroup.variables.Item('dreepyprefix')
    if ($null -eq $prefix) {
        $message = "Variable Group {0} does not contain a variable named 'dreepyprefix'. Add a variable called 'dreepyprefix' to Variable Group {0} and set the value to the prefix that all environment variables should have." -f $variableGroup.name
        Write-Error $message
        Throw
    }
    else {
        Return $prefix
    }
}