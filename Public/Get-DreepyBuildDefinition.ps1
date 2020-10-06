Function Get-DreepyBuildDefinition{
    param(
        [parameter(Mandatory = $false)][string]$buildDefinitionName = $env:BUILD_DEFINITIONNAME
    )
        $message = "Getting all variables under variable groups for build {0}." -f $buildDefinitionName
    Write-Host $message
    $buildDefinitionShow = az pipelines build definition show --name $buildDefinitionName --detect true

    if ($null -eq $buildDefinitionShow){
        Write-Error "Buld not found!"
        Throw
    }
    return $buildDefinitionShow
}