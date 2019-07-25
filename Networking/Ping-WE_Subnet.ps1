<#
To-do: (1) Set NetworkAddress Parameter to IP type. (2) Create Subnet Calculator Tool (3) Tie calculator to ping script (4) scan range based on subnet mask (5) redirect warning output to $Property variable
Fix parameter input on $Range. Doesn't accept 1..10 as input
#>

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
    $Old_ErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'
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
    $ErrorActionPreference = $Old_ErrorActionPreference
}