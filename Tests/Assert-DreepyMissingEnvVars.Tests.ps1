Set-Location $PSScriptRoot
Import-Module "..\Dreepy.psd1" -Force
Import-Module "./Helper/*.ps1" -Force

Describe "Run Assert on Both Variable Groups" {
    it "Get Missing Variables" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 14
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition
        $AssertCount | Should -BeExactly 12
    }

    it "Create EnvVar and Get Missing Variables" {
        $env:zacian = 'zacian'
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 14
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition
        $AssertCount | Should -BeExactly 11
        Remove-Item env:zacian
    }

    it "Create EnvVar and Get Missing Variables That Are Masked Only" {
        $env:zacian = 'zacian'
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 14
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition -maskedValuesOnly
        $AssertCount | Should -BeExactly 5
        Remove-Item env:zacian
    }


    it "Get Missing Variables That Are Masked Only" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 14
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition -maskedValuesOnly
        $AssertCount | Should -BeExactly 6
    }

    it "Get Missing Variables And Include PreFix" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 5
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition -variableGroupNames "envvars" -includePrefix -maskedValuesOnly
        $AssertCount | Should -BeExactly 2
    }

    it "Get Missing Variables And Include Suffix" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 5
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition -variableGroupNames "envvars" -includeSuffix -maskedValuesOnly
        $AssertCount | Should -BeExactly 2
    }

    it "Get Missing Variables And Include Suffix" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 5
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition -variableGroupNames "envvars" -includeSuffix -maskedValuesOnly
        $AssertCount | Should -BeExactly 2
    }

    it "Should Raise Warning" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 5
        $AssertCount = Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition -variableGroupNames "envvars" -includeSuffix -maskedValuesOnly -reportingLevel "Warning"
        $AssertCount | Should -BeExactly 2
    }


    it "Should Throw" {
        $buildDefinition = Get-Content ./SampleBuildDefinition/buildDefinition.json
        $variableGroups = Get-DreepyVariableGroupsFromBuildDefinition -buildDefinition $buildDefinition -variableGroupNames "envvars"
        $totalNumberOfVars = Get-CountOfVariables -variableGroups $variableGroups
        $totalNumberOfVars | Should -BeExactly 5
        {Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition -variableGroupNames "envvars" -includeSuffix -maskedValuesOnly -reportingLevel "Error"} | Should -Throw
    }
}