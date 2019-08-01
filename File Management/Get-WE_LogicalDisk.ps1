Function Get-WE_LogicalDisk {

    <#

    .SYNOPSIS
        Synopsis here

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

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('HostName', 'MachineName')]
        [String[]]
        $ComputerName

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        ForEach ($Computer in $ComputerName) {

            Try {

                $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
                $LogicalDisk = Get-CimInstance -CimSession $Session -ClassName Win32_DiskDrive
                $Property = [Ordered]@{
                    ComputerName = $Computer
                    Status       = 'Connected'
                }

                ForEach ($Disk in $LogicalDisk) {

                    $Index = $Disk.Index
                    $Property += @{
                        "Name[$Index]"            = $Disk.Name
                        "Partitions[$Index]"      = $Disk.Partitions
                        "Size[$Index] (GB)"       = $Disk.Size
                        "FreeSpace[$Index] (GB)"  = $Disk.FreeSpace
                        "Used Space[$Index] (GB)" = $Disk.UsedSpace
                        "DeviceID[$Index]"        = $Disk.DeviceID
                    }

                }

            }

            Catch {

                Write-Verbose "Could not fetch the logical disks from $Computer."
                $Property = [Ordered]@{
                    ComputerName = $Computer
                    Status       = 'Disconnected'
                }

            }

            Finally {

                $Object = New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }
        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}