Function Set-WE_NTP {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Ensure the target machine's net adapter is configured with a public DNS server such as Google public DNS 8.8.8.8.

    .PARAMETER
        -NTPPeerList [<String[]>]
            Don't separate multiple servernames with a comma.

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
            -Useful for managing NTP servers on non-domain computers.

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

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