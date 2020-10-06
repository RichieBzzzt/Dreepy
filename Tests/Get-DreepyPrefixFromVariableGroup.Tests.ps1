Set-Location $PSScriptRoot
Import-Module "..\Private\Get-DreepyPrefixFromVariableGroup.ps1" -Force

Describe "Return Prefix" {
    it "Should Return A Prefix Value" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroup = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $prefix = Get-DreepyPrefixFromVariableGroup -variableGroup $variableGroup
        $prefix.Item('value') | Should -BeExactly 'galar'
    }

    it "Should Throw As No Dreepy Prefix" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinitionMissingPrefixSuffix.json
        $variableGroup = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        {Get-DreepyPrefixFromVariableGroup -variableGroup $variableGroup} | Should -Throw
    }
}