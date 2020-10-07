Set-Location $PSScriptRoot
Import-Module "..\Dreepy.psm1" -Force
Import-Module "..\Private\Get-DreepyVariableGroupsFromBuildDefinition.ps1" -Force
Import-Module "..\Private\Get-DreepySuffixFromVariableGroup.ps1" -Force
Import-Module "./Helper/Get-CountOfVariables.ps1" -Force

Describe "Return Suffix" {
    it "Should Return A Suffix Value" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroup = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $Suffix = Get-DreepySuffixFromVariableGroup -variableGroup $variableGroup
        $Suffix.Item('value') | Should -BeExactly 'tundra'
    }

    it "Should Throw As No Dreepy Suffix" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinitionMissingPrefixSuffix.json
        $variableGroup = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        {Get-DreepySuffixFromVariableGroup -variableGroup $variableGroup} | Should -Throw
    }
}