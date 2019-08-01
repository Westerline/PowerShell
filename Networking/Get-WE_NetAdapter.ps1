<#
.Notes
    To Do: add for loop to add multiple adapters + Index to hash table
#>

Function Get-WE_NetAdapter {

    [Cmdletbinding()]

    Param (

        [Parameter(Mandatory = $True,
            Position = 0)]
        [validateset('Ethernet', 'Wi-Fi', 'Bluetooth', 'Virtual')]
        [String]
        $Type

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'

            Switch ($Type) {

                Ethernet { $Adapter = Get-NetAdapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.3*' } }
                Wi-Fi { $Adapter = Get-NetAdapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.11*' } }
                Bluetooth { $Adapter = Get-NetAdapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Bluetooth*' } }
                Virtual { $Adapter = Get-NetAdapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Unspecified*' } }

            }

            $ErrorActionPreference = $StartErrorActionPreference

        }

        Catch {

            Write-Verbose "Unable to find $Type network adapter."
            $Adapter = "Unable to find $Type network adapter."

        }

        Finally {

            Write-Output $Adapter

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}