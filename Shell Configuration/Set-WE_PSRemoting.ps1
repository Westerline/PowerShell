<#
.DESCRIPTION
    Remote Endpoint Configuration
    Step 1: Local Account Token
    Step 2: Enable-PSRemoting
    Step 3: Enable Legacy HTTP Listener on Port 80 (Optional)
    Client-side
    Configure the machines you the client can remote to.
    To do: set-netconnectionprofile private
#>

Function Set-WE_PSRemoting {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('HostName', 'ComputerName')]
        [String[]]
        $TrustedHosts,

        [Switch]
        $HttpListener,

        [Switch]
        $HttpsListener

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $PSRemoting = Enable-PSRemoting

            If ($TrustedHosts.IsPresent) {

                Set-Item WSMan:\localhost\Client\TrustedHosts -Value $TrustedHosts -Concatenate

            }

            If ($HttpListener.IsPresent) {

                Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener -Value True -Confirm:$False

            }

            If ($HttpsListener.IsPresent) {

                Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value True -Confirm:$False

            }

            $PSRemotingHosts = Get-Item WSMan:\localhost\Client\TrustedHosts
            $AllowRemoteAccess = Get-Item WSMan:\localhost\Service\AllowRemoteAccess
            $PSRemotingHTTP = Get-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener
            $PSRemotingHTTPS = Get-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener
            $Property = @{
                Status            = 'Successful'
                PSRemoting        = $PSRemoting
                AllowRemoteAccess = $AllowRemoteAccess.Value
                TrustedHosts      = $PSRemotingHosts.Value
                HTTPListener      = $PSRemotingHTTP.Value
                HTTPSListener     = $PSRemotingHTTPS.Value
            }

        }

        Catch [System.InvalidOperationException] {

            Write-Verbose "Network connection profile is set to Public. Please change your network connection profile to private and try again."
            $Property = @{
                Status            = 'Unsuccessful: Public Network Profile'
                PSRemoting        = $PSRemoting
                AllowRemoteAccess = $AllowRemoteAccess.Value
                TrustedHosts      = $PSRemotingHosts.Value
                HTTPListener      = $PSRemotingHTTP.Value
                HTTPSListener     = $PSRemotingHTTPS.Value
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