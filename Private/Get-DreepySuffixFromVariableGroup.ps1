Function Get-DreepySuffixFromVariableGroup {
    param($variableGroup)

    $suffix = $variableGroup.variables.Item('dreepysuffix')
    if ($null -eq $suffix) {
        $message = "Variable Group {0} does not contain a variable named 'dreepysuffix'. Add a variable called 'dreepysuffix' to Variable Group {0} and set the value to the suffix that all environment variables should have." -f $variableGroup.name
        Write-Error $message
        Throw
    }
    else {
        Return $suffix
    }
}