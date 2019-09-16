Function Set-WE_HighPerformance {

    <#

    .SYNOPSIS
        Enables High Performance power plan. Also configures monitor, disk, standby, and hibernate timeout.

    .DESCRIPTION
        Command description here.

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

        <CommonParameters>
            This cmdlet supports the common parameters: Verbose, Debug,
            ErrorAction, ErrorVariable, WarningAction, WarningVariable,
            OutBuffer, PipelineVariable, and OutVariable. For more information, see
            about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -
        To Do:
            -
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $MonitorTimeout = 15,

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $DiskTimeout = 20,

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $StandbyTimeout = 30,

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $HibernateTimeout = 30

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $HighPerformance = Get-WmiObject -NS root\cimv2\power -Class win32_PowerPlan -Filter "ElementName ='High Performance'"
            $PowerPlan = $HighPerformance.Activate()
            $Monitor = & .\PowerCFG.exe -x -monitor-timeout-ac $MonitorTimeout -monitor-timeout-dc $MonitorTimeout
            $Disk = & .\PowerCFG.exe -x -disk-timeout-ac $DiskTimeout -disk-timeout-dc $DiskTimeout
            $Standby = & .\PowerCFG.exe -x -standby-timeout-ac $StandbyTimeout -standby-timeout-dc $StandbyTimeout
            $Hibernate = & .\PowerCFG.exe -x -hibernate-timeout-ac $HibernateTimeout -hibernate-timeout-dc $HibernateTimeout
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                PowerPlan = $PowerPlan
                Monitor   = $Monitor
                Disk      = $Disk
                Standby   = $Standby
                Hibernate = $Hibernate
            }

        }

        Catch {

            Write-Verbose "Unable to set $Env:COMPUTERNAME's power plan to high performance."
            $Property = @{
                Status            = 'Unsuccessful'
                ComputerName      = $Env:COMPUTERNAME
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}