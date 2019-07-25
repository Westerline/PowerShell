<#
To do: format output, see if output can still be done without the $DiskArray. Limit to one Try/Catch. Get rid of array, add to hash table instead.
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

ForEach ($Computer in $ComputerName) {

    Try {

        $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
        $LogicalDisk = Get-CimInstance -CimSession $Session -ClassName Win32_DiskDrive
        $DiskArray = @()
        ForEach ($Disk in $LogicalDisk) {

            Try {
        
                $Property = @{
                    Computername = $Computer
                    Stauts       = 'Connected'
                    Name         = $Disk.Name
                    Size         = $Disk.Size
                    Partitions   = $Disk.Partitions
                }
            
            }

            Catch { 

                $Property = @{
                    Computername = $Computer
                    Stauts       = 'Connected'
                    Name         = 'Null'
                    Size         = 'Null'
                    Partitions   = 'Null'
                }

            }

            Finally {

                $Object = New-Object -TypeName PSObject -Property $Property
                $DiskArray += $Object

            }

        }

    }

    Catch {

        $Property = @{
            Computername = $Computer
            Stauts       = 'Disconnected'
            Name         = 'Null'
            Size         = 'Null'
            Partitions   = 'Null'
        }
        $Object = New-Object -TypeName PSObject -Property $Property
        $DiskArray += $Object

    }
    
    Finally { 

        Write-Output $DiskArray

    }
}