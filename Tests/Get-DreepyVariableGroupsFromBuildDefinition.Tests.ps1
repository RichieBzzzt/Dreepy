Set-Location $PSScriptRoot
Import-Module "..\Private\*.ps1" -Force
Import-Module "..\Public\*.ps1" -Force
Import-Module "./Helper/*.ps1" -Force

Describe "Getting Variable Groups from Build Definition" {
    it "Should return two Variable Groups" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition
        $variableGroups.Length | Should -BeExactly 2
    }

    it "Should return two Variable Groups" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $variableGroups.Length | Should -BeExactly 1
    }

    it "Should Throw as no VariableGroup Exists" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        {Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "bob"} | Should -Throw
    }
}