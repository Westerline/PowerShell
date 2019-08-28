Function Set-WE_PSRemoting {

    <#

    .SYNOPSIS
        Enables PowerShell remoting with optional features.

    .DESCRIPTION
        Enables PowerShell remoting with optional features.
        Step 1: Local Account Token
        Step 2: Enable-PSRemoting
        Step 3: Enable Legacy HTTP Listener on Port 80 (Optional)
        Client-side
        Configure the machines you the client can remote to.
        To do: set-netconnectionprofile private

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

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
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

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
        $HttpsListener,

        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $PSRemoting = Enable-PSRemoting -Force:$Force

            If ($TrustedHosts.IsPresent) {

                Set-Item WSMan:\localhost\Client\TrustedHosts -Value $TrustedHosts -Concatenate -Force:$Force

            }

            If ($HttpListener.IsPresent) {

                Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener -Value True -Confirm:$False -Force:$Force

            }

            If ($HttpsListener.IsPresent) {

                Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value True -Confirm:$False -Force:$Force

            }

            $PSRemotingHosts = Get-Item WSMan:\localhost\Client\TrustedHosts
            $AllowRemoteAccess = Get-Item WSMan:\localhost\Service\AllowRemoteAccess
            $PSRemotingHTTP = Get-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener
            $PSRemotingHTTPS = Get-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener
            $ErrorActionPreference = $StartErrorActionPreference
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
                Status            = 'Unsuccessful'
                ComputerName      = $Env:COMPUTERNAME
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
            }

        }

        Catch {

            Write-Verbose "Unable to set PS remoting."
            $Property = @{
                Status            = 'Unsuccessful'
                ComputerName      = $Env:COMPUTERNAME
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
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