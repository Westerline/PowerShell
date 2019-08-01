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

    [CmdletBinding(SupportsShouldProcess)]

    Param(

        [Parameter(ParameterSetName = "Enable")]
        [Switch]
        $Enable,

        [Parameter(ParameterSetName = "Disable")]
        [Switch]
        $Disable

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ProxyRegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
            $ErrorActionPreference = 'Stop'

            If ($Enable.IsPresent) {

                Set-ItemProperty -Path $ProxyRegKey ProxyEnable -Value 1

            }

            ElseIf ($Disable.IsPresent) {

                Set-ItemProperty -Path $ProxyRegKey ProxyEnable -Value 0

            }

            $Proxy = Get-ItemProperty -path $ProxyRegKey

            Switch ($Proxy.ProxyEnable) {

                1 { $ProxyStatus = 'Enabled' }
                0 { $ProxyStatus = 'Disabled' }
                Default { $ProxyStatus = 'Invalid Registry Value' }

            }

            $ErrorActionPreference = $StartErrorActionPreference

            $Property = @{
                ProxyStatus   = $ProxyStatus
                ProxyOverride = $Proxy.ProxyOverride
            }

        }

        Catch {

            Write-Verbose "Unable to change proxy settings."
            $Property = @{
                ProxyStatus   = 'Null'
                ProxyOverride = 'Null'
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