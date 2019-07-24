<#
To do: (1) separate gpresult command (2) take before/after snapshots of GPO and see what changed (3) Individual targets
#>

Param (
    [Switch] $Logoff = '/Logoff',
    [Switch] $Boot = '/Boot',
    [Switch] $Target:Computer = '/Target:Computer',
    [Switch] $Target:User = '/Target:User'
    
)

Begin { }

Process {

    Try {
    
        $Update = & gpupdate.exe $Logoff $Boot $Target:Computer $Target:User
        $TrimmedUpdate = $Update | Where-Object { $_.trim() -ne "" }
        $Property = @{ }
    }

    Catch { 
        Write-Verbose "Unable to update group policy on $Env:ComputerName"
        $Property = @{ }
    }

    Finally {

        Write-Output $TrimmedUpdate

    }

}

End { }