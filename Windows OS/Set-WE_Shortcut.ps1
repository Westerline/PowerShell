Function Set-Shortcut {
    param ( [string]$SourceExe, [string]$ArgumentsToSourceExe, [string]$DestinationPath )
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($DestinationPath)
    $Shortcut.TargetPath = $SourceExe
    $Shortcut.Arguments = $ArgumentsToSourceExe
    $Shortcut.Save()
}

#Set-Shortcut "C:\temp\.lnk" "C:\test.exe"