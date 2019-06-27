[CmdletBinding()]

Param (
    [String[]] $Hostname,
    [String] $ServerInstance = '',
    [String] $Database,
    [String] $SQLScriptPath
    
)

Try {

    $Script = Invoke-Sqlcmd -ServerInstance $ServerInstance -HostName $HostName -Database $Database -InputFile $SQLScriptPath -ErrorAction Stop

    $Property = @{Hostname = $Hostname
        Database      = $Database
        Status        = 'Connected'
        ScriptResults = $Script
    }

}

Catch {

    $Property = @{Hostname = $Hostname
        Database      = $Database
        Status        = 'Disconnected'
        ScriptResults = 'Null'
    }

}


Finally {

    $Object = New-Object -TypeName psobject -Property $Property
    Write-Output $Object

}