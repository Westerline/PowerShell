param ( 

    [string]$Target, 
    [string]$Argument, 
    [string]$Path,
    [String]$FileName 

)

Try {

    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($Path + '\' + $FileName + '.lnk')
    $Shortcut.TargetPath = $Target
    $Shortcut.Arguments = $Argument
    $Shortcut.Save()
    $Property = @{
        FullName   = $Shortcut.FullName
        TargetPath = $Shortcut.TargetPath
        Arguments  = $Shortcut.Arguments
    }

}

Catch { 
    $Property = @{
        FullName   = 'Null'
        TargetPath = 'Null'
        Arguments  = 'Null'
    }
}

Finally {
    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}