#Create Module Manifest
$Modules = Get-ChildItem -Path "C:\Github" -Recurse -Filter *.psm1

Foreach ($Module in $Modules) {

    $FileName = $Module.Name.Replace('.psm1', '')
    $Path = ($Module.DirectoryName + "\" + $FileName + ".psd1")
    $RootModule = ($FileName + ".psm1")
    $ModuleSettings = @{
        Path              = $Path
        Author            = "Wesley Esterline"
        ModuleVersion     = "1.0.0"
        PowerShellVersion = "5.0"
        RootModule        = $RootModule
        FunctionsToExport = $FileName
        CmdletsToExport   = '*'
        VariablesToExport = '*'
        AliasesToExport   = '*'
    }

    New-ModuleManifest @ModuleSettings

}

#Create Module Directory
$New_Object = Get-ChildItem -Path "C:\Github" -Recurse -Filter *psremoting.psm1

Foreach ($Object in $New_Object) {

    $FileName = $Object.Name.Replace('.psm1', '')
    Move-Item -Path $Object.FullName -Destination ($Object.DirectoryName + "\" + $FileName + "\" + $Object.Name)

}