Function Set-WE_PSRemoting {

    <#

    .SYNOPSIS
        Enables PowerShell remoting with optional features.

    .DESCRIPTION
        Enables PowerShell remoting with optional features.
        #Ensure the network firewall is running, otherwise can't create any other listeners
        If you run into a "wsman-config access denied" error, try creating a new admin user or verify the existing user is part of the adminstrators group.
        Step 2: Enable-PSRemoting
        Step 3: Enable Legacy listeners (optional)
        Client-side
        Configure the machines the client can connect to.

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
            -Set Firewall command -Enabled parameter to use a switch parameter
            -Create a separate script with Command Prompt Compatability:
                {
                    sc config "MpsSvc" start= "auto"
                    net start "MpsSvc"
                    NetSh Advfirewall set allprofiles state on
                }
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
            Set-Service -Name 'MpsSvc' -StartupType Automatic | Start-Service
            Set-NetFirewallProfile -All -Enabled True
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

            $PSRemotingHosts = Get-Item WSMan:\localhost\Client\TrustedHosts -Force:$Force
            $AllowRemoteAccess = Get-Item WSMan:\localhost\Service\AllowRemoteAccess -Force:$Force
            $PSRemotingHTTP = Get-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener -Force:$Force
            $PSRemotingHTTPS = Get-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Force:$Force
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