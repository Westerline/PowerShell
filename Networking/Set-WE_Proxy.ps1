<#
.To Do
    Parameter sets for enable/disable

#>

Function Set-WE_Proxy {

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