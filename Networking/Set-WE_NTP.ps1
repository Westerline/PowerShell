<#
.Description
    Useful for managing NTP servers for non-domain computers.
.Example
    For NTPPeerList parameter, don't separate the server
.Requirements
    Net adapter configured with Public DNS server such as Google public DNS 8.8.8.8
#>

Function Set-WE_NTP {

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('ServerName', 'NTPServer', 'TimeServer')]
        [String[]]
        $NTPPeerList = "0.nz.pool.ntp.org, 1.nz.pool.ntp.org, 2.nz.pool.ntp.org, 3.nz.pool.ntp.org"

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            Set-Service -Name W32Time -StartupType Automatic
            Start-Service -Name W32Time
            $W32TimeService = Get-Service -Name W32Time
            $W32TimeConfig = & w32tm.exe /config /syncfromflags:manual /manualpeerlist:$NTPPeerList /update
            $W32TimeResync = & w32tm.exe /resync /rediscover
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                Status         = 'Successful'
                W32TimeService = $W32TimeService
                W32TimeConfig  = $W32TimeConfig
                W32TimeResync  = $W32TimeResync
            }

        }

        Catch {

            Write-Verbose "Unable to configure NTP settings for $Env:ComputerName, please check the network adapter DNS settings and try again."
            $Property = @{
                Status         = 'Unsuccessful'
                W32TimeService = 'Null'
                W32TimeConfig  = 'Null'
                W32TimeResync  = 'Null'
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