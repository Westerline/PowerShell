Function Set-WE_Proxy {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

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
            -Determine method to require either Enable or Disable switch to be active.
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $True,
            ParameterSetName = "Enable")]
        [Switch]
        $Enable,

        [Parameter(Mandatory = $True,
            ParameterSetName = "Disable")]
        [Switch]
        $Disable,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ProxyRegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
            $ErrorActionPreference = 'Stop'

            If ($Enable.IsPresent) {

                Set-ItemProperty -Path $ProxyRegKey ProxyEnable -Value 1 -Force:$Force

            }

            ElseIf ($Disable.IsPresent) {

                Set-ItemProperty -Path $ProxyRegKey ProxyEnable -Value 0 -Force:$Force

            }

            $Proxy = Get-ItemProperty -path $ProxyRegKey

            Switch ($Proxy.ProxyEnable) {

                1 { $ProxyStatus = 'Enabled' }
                0 { $ProxyStatus = 'Disabled' }
                Default { $ProxyStatus = 'Invalid Registry Value' }

            }

            $ErrorActionPreference = $StartErrorActionPreference

            $Property = @{
                Status        = 'Successful'
                ComputerName  = $Env:COMPUTERNAME
                ProxyStatus   = $ProxyStatus
                ProxyOverride = $Proxy.ProxyOverride
            }

        }

        Catch {

            Write-Verbose "Unable to change proxy settings."
            $Property = @{
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