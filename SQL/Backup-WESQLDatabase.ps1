[CmdletBinding()]

Param (

    [String] $Instance = '',
    [String] $Database,
    [String] $Path
    
)

Try {

    $Backup = (Invoke-Sqlcmd -ServerInstance $Instance -Query "BACKUP DATABASE [$Database] TO DISK = '$Path'") | Tee

    $Property = @{Hostname = $Hostname
        Database      = $Database
        Status        = 'Successful'
        BackupResults = $Backup
    }

}

Catch {

    $Property = @{Hostname = $Hostname
        Database      = $Database
        Status        = 'Unsuccessful'
        BackupResults = 'Null'
    }

}

FInally {

    $Object = New-Object -TypeName psobject -Property $Property
    Write-Output $Object

}