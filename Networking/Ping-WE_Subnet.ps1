<#
To-do: (1) Set NetworkAddress Parameter to IP type. (2) Create Subnet Calculator Tool (3) Tie calculator to ping script (4) scan range based on subnet mask (5) redirect warning output to $Property variable
Fix parameter input on $Range. Doesn't accept 1..10 as input
#>

Function Ping-WE_Subnet {

    [CmdletBinding()]

    Param (

        [ValidateNotNullOrEmpty()]
        [String]
        $NetworkAddress = '192.168.1',

        [ValidateRange(0, 255)]
        [Int]
        $Range = 1..40

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($R in $Range) {

            Try {

                $Ping = Test-NetConnection -ComputerName "$NetworkAddress.$R" -WarningAction SilentlyContinue -InformationLevel Quiet
                $Property = @{
                    ComputerName  = "$NetworkAddress.$R"
                    PingSucceeded = $Ping
                }

            }

            Catch {

                Write-Output "Unable to ping subnet $NetworkAddress in range $Range"
                $Property = @{
                    ComputerName  = "$NetworkAddress.$R"
                    PingSucceeded = 'NULL'
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