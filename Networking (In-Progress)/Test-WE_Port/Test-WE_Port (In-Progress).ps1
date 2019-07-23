<#
.Description
    PortQryV2.exe required
    https://support.microsoft.com/en-za/help/310099/description-of-the-portqry-exe-command-line-utility
    Allows for testing of UDP and TCP ports, particularly useful for DNS name queries.
    Well-known ports range from 0 through 1023.
    Registered ports are 1024 to 49151
    Can test on multiple ports
#>

Param(
    [String] $HostName,
    [ValidateSet('TCP', 'UDP')]
    [String] $Protocol,
    [ValidateRange(0, 49151)]
    [Int[]] $Port

)

Try {
    $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $HostName -p $Protocol -e $Port
    $DNSResolve = $PortQry | Select-String -Pattern 'Port'
    $TestPort = $PortQry | Select-String -Pattern 'Resolved'
    $Property = @{
        HostName   = $HostName
        DNSResolve = $DNSResolve
        TestPort   = $TestPort
    }
}

Catch {
    $Property = @{
        HostName   = $HostName
        DNSResolve = 'Null'
        TestPort   = 'Null'
    }
}

Finally {
    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}