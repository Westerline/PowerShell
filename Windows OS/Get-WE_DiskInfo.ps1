<#
#>
Function Get-WE_DiskInfo {

    [Cmdletbinding()]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('HostName')]
        [String[]] $ComputerName,

        [ValidateNotNullOrEmpty()]
        [Int] $DriveType = 3
    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Computer in $ComputerName) {

            $ErrorActionPreference = 'Stop'

            Try {

                $Disk = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter "DriveType = $DriveType"

                Foreach ($D in $Disk) {

                    Try {

                        $FreeSpace = ($D.FreeSpace / 1GB).Toint32($Null)
                        $Size = ($D.Size / 1GB).Toint32($Null)
                        $UsedSpace = ($Size - $FreeSpace)
                        $Property = @{
                            Computer          = $Computer
                            'FreeSpace (GB)'  = $FreeSpace
                            'Size (GB)'       = $Size
                            'Used Space (GB)' = $UsedSpace
                            DeviceID          = $D.DeviceID
                        }

                    }

                    Catch {

                        $Property = @{
                            Computer          = $Computer
                            'FreeSpace (GB)'  = 'Null'
                            'Size (GB)'       = 'Null'
                            'Used Space (GB)' = 'Null'
                            DeviceID          = 'Null'
                        }

                    }

                    Finally {

                        $Object = New-Object -TypeName PSObject -Property $Property
                        Write-Output $Object
    
                    }

                }

            }

            Catch {
            
                Write-Output "$Computer unavailable."

            }

        }
    
    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference 

    }

}