Set-Location $PSScriptRoot
Import-Module "..\Public\Get-DreepyMissingEnvVars.ps1" -Force
Import-Module "..\Private\Get-DreepyVariableGroupsFromBuildDefinition.ps1" -Force

Describe "Get Missing Environment Vars" {
    it "Should Return Three Missing Variables" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroup = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $missingVars = Get-DreepyMissingEnvVars -variableGroup $variableGroup
        $missingVars.Length | Should -BeExactly 3
    }

    it "Crate EnvVar Should Return Two Missing Variables" {
        $env:zacian = 'zacian'
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroup = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $missingVars = Get-DreepyMissingEnvVars -variableGroup $variableGroup
        $missingVars.Length | Should -BeExactly 2
        Remove-Item env:zacian
    }
}