<#
To do: format output, see if output can still be done without the $DiskArray. Limit to one Try/Catch. Get rid of array, add to hash table instead.
#>

Function Get-WE_LogicalDisk {

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