<#
To do: (1) separate gpresult command (2) take before/after snapshots of GPO and see what changed (3) Individual targets
#>

[Cmdletbinding(SupportsShouldProcess)]

Param (

    [Parameter(ParameterSetName = 'Logoff')]
    [Switch] $Logoff = '/Logoff',

    [Parameter(ParameterSetName = 'Boot')]
    [Switch] $Boot = '/Boot',

    [Parameter(ParameterSetName = 'Computer')]
    [Switch] $Target:Computer = '/Target:Computer',

    [Parameter(ParameterSetName = 'User')]
    [Switch] $Target:User = '/Target:User'
    
)

Begin { }

Process {

    Try {
    
        $Update = & gpupdate.exe $Logoff $Boot $Target:Computer $Target:User
        $TrimmedUpdate = $Update | Where-Object { $_.trim() -ne "" }
    }

    Catch { 
        Write-Verbose "Unable to update group policy on $Env:ComputerName"
    }

    Finally {

        Write-Output $TrimmedUpdate

    }

}

End { }