# Dreepy
Check that environment variables have been created for any masked variables included in a Variable Group.

[![Build Status](https://bzzztio.visualstudio.com/Dreepy/_apis/build/status/RichieBzzzt.Dreepy?branchName=main)](https://bzzztio.visualstudio.com/Dreepy/_build/latest?definitionId=45&branchName=main)

## How Does It Work?

Dreepy is a PowerShell module to verify Environment variables exist for all variables in a variable group that are attached to running build.

It can be run outside ofa build pipeline, providing you specify the organisation, project, and build variables. By default these are set to environment variables in Azure DevOps - 

```powershell
Function Get-DreepyBuildDefinition{
    param(
        [parameter(Mandatory = $false)][string]$buildDefinitionName = $env:BUILD_DEFINITIONNAME
    )
```

```powershell
Function Connect-DreepyAzDevOpsCli {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false, ParameterSetName='AzDo')][string]$organisationUri = $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI,
        [parameter(Mandatory = $false, ParameterSetName='AzDo')][string]$Project = $env:SYSTEM_TEAMPROJECT,
        [parameter(Mandatory = $true)][string]$patToken
    )
```

It can check either all of the Variable Groups that are attached to a build, or a subset of VariableGroups can be specified as an array when using the variable ```variableGroupNames``` on the cmdlet ```Assert-DreepyMissingEnvVars```.

## Is There a Naming Convention Expected of Variables?

Because some environment variables may have been created with a name different to the variable in the variable group with a prefix or a suffix, you can specify ```includeprefix``` or ```includesuffix```. Add a variable to your variable group called ```dreepyprefix``` or ```dreepysuffix```. The value of this variable is then used to prepend/append to each of the variables in the variable group to check for environment variables.

For example, if I have a variable group with three variables that are masked (var1 var2 var3) then I could pass in environment variables named the following and they would be found - 
```
Env:$var1
Env:$var2
Env:$var3
```

If I added a variable to the variable group called ```dreepyprefix``` and set the value as "scope-" it would search for the following environment variables:
```
Env:$scope-var1
Env:$scope-var2
Env:$scope-var3
```

If I added a variable to the variable group called ```dreepysuffix``` and set the value as "-domain" it would search for the following environment variables:
```
Env:$var1-domain
Env:$var2-domain
Env:$var3-domain
```

And if I used both ```dreepyprefix``` and ```dreepysuffix``` it would search for the following environment variables:
```
Env:$scope-var1-domain
Env:$scope-var2-domain
Env:$scope-var3-domain
```

## Why is This Necessary?

For each variable stored in a variable group, all variables have environment variables created for them __with the exception masked variables__. When masked variables are used in a script you have to [create them as environment variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=classic%2Cbatch#secret-variables) for them to be accessable in a script. 

This manual step is a pain to remember, so Dreepy can be run as part of the step that makes use of the variables stored in the variable groups and checks that environment variables have been created.

## Can You Just Not Create The Environment Variables Programmatically?

Despite much hacking I have not been abel to get the values of the variable groups. So it is still very much a manual process. This includes both YAML and Classic pipelines. Sorry! The effort here was to make sure that when a variable was added to a variable group then the step to add an enviroment variable was not forgotten, as that seems to be the case.

## I Only Care About Variables with Masked Value...

use the switch ```maskedValuesOnly``` on the cmdlet ```Assert-DreepyMissingEnvVars``` to only check for Environment Variables on variables that are masked. 

## How Do I Use It?

You will need to create a [PAT Token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) with the READ Build Scope. Then you can log in using ```Connect-DreepyAzDevOpsCli```. After that you grab the Build Definition of the current build and then check the variable groups.

```powershell
Install-Module Dreepy -Scope CurrentUser -Force 
Connect-DreepyAzDevOpsCli -patToken $(patToken) 
$buildDefinition = Get-DreepyBuildDefinition
Assert-DreepyMissingEnvVars -buildDefinition $buildDefinition
```

```Assert-DreepyMissingEnvVars``` has a ```reportingLevel``` setting, which by default is set to ```Info```. It accepts two other settings ```Warning``` and ```Error```. This means that you can fail on missing environment variables. 

## Any Limitations/Assumptions?

For each task in Azure DevOps, you can check for all variable group, or just one variable group of a build. However you cannot select a subset of variables stored in a variable group.
You can specify prefix for one variable group, then suffix for anotehr variable group, however you would need to specify the variable group.