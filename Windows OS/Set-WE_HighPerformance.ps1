<#
.DESCRIPTION
    Section 1: Enable High Performance
    Section 2: Configure monitor, disk, standby, and hibernate timeout.
#>

[CmdletBinding(SupportsShouldProcess)]

Param (

    [ValidateNotNullOrEmpty()]
    [Int]
    $MonitorTimeout = 15,
    
    [ValidateNotNullOrEmpty()]
    [Int] 
    $DiskTimeout = 20,
    
    [ValidateNotNullOrEmpty()]
    [Int] 
    $StandbyTimeout = 30,

    [ValidateNotNullOrEmpty()]
    [Int] 
    $HibernateTimeout = 30
    
)

Begin { }

Process {

    Try {

        $HighPerformance = Get-WmiObject -NS root\cimv2\power -Class win32_PowerPlan -Filter "ElementName ='High Performance'"
        $PowerPlan = $HighPerformance.Activate()
        $Monitor = & .\PowerCFG.exe -x -monitor-timeout-ac $MonitorTimeout -monitor-timeout-dc $MonitorTimeout
        $Disk = & .\PowerCFG.exe -x -disk-timeout-ac $DiskTimeout -disk-timeout-dc $DiskTimeout
        $Standby = & .\PowerCFG.exe -x -standby-timeout-ac $StandbyTimeout -standby-timeout-dc $StandbyTimeout
        $Hibernate = & .\PowerCFG.exe -x -hibernate-timeout-ac $HibernateTimeout -hibernate-timeout-dc $HibernateTimeout
        $Property = @{
            PowerPlan = $PowerPlan
            Monitor   = $Monitor
            Disk      = $Disk
            Standby   = $Standby
            Hibernate = $Hibernate
        }
    }

    Catch {
        $Property = @{
            PowerPlan = 'Null'
            Monitor   = 'Null'
            Disk      = 'Null'
            Standby   = 'Null'
            Hibernate = 'Null'
        }
    }

    Finally {
        $Object = New-Object -TypeName PSObject -Property $Property 
        Write-Output $Object
    }

}

End { }