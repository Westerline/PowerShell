<#
.DESCRIPTION
    Section 1: Enable High Performance
    Section 2: 
.Requirements
    PowerCFG.exe CommandLine Utility
#>

[CmdletBinding()]

Param (
    [Int] $MonitorTimeout,
    [Int] $DiskTimeout,
    [Int] $StandbyTimeout,
    [Int] $HibernateTimeout
)

Begin { }

Process {

    Try {

        $HighPerformance = Get-WmiObject -NS root\cimv2\power -Class win32_PowerPlan -Filter "ElementName ='High Performance'"
        $HighPerformance.Activate()
        $Monitor = & .\PowerCFG.exe -x -monitor-timeout-ac $MonitorTimeout -monitor-timeout-dc $MonitorTimeout
        $Disk = & .\PowerCFG.exe -x -disk-timeout-ac $DiskTimeout -disk-timeout-dc $DiskTimeout
        $Standby = & .\PowerCFG.exe -x -standby-timeout-ac $StandbyTimeout -standby-timeout-dc $StandbyTimeout
        $Hibernate = & .\PowerCFG.exe -x -hibernate-timeout-ac $HibernateTimeout -hibernate-timeout-dc $HibernateTimeout
        $Property = @{
            
        }
    }

    Catch {


    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}