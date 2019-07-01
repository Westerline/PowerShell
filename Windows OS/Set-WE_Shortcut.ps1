param ( 

    [string]$Target, 
    [string]$Argument, 
    [string]$Path,
    [String]$FileName 

)

$Shell = New-Object -ComObject WScript.Shell

$Shortcut = $Shell.CreateShortcut($Path + '\' + $FileName + '.lnk')

$Shortcut.TargetPath = $Target

$Shortcut.Arguments = $Argument

$Shortcut.Save()