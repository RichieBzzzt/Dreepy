# Dreepy
Check that environment variables have been created for any masked variables included in an Variable Group.

## How Does It Work?

Currently, this will only run in an Azure DevOps pipeline. 

For each variable stored in a variable group, all variables have environment variables created for them __with the exception masked variables__. When masked variables are used in a script you have to [create them as environment variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=classic%2Cbatch#secret-variables) for them to be accessable in a script. 


## How Do I Use It?
You will need to create a [PAT Token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page) with the READ Build Scope and pass that in to the sole function that is executed.

```powershell
Install-Module Dreepy -Scope CurrentUser -Force 
Get-DreepyMissingEnvVars -patToken $(patToken)
```

## Any Limitations/Assumptions?

It is assumed that the names ofthe environment variables are the same as the name of the variables in the Variable Group. Any deviations are not currently accounted for. You can always fork and add a prefix if you want :-)
