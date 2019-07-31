<#
#>

Function Install-WE_Chocolatey {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Switch] $Proxy

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            If ($Proxy.IsPresent) {

                [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

            }

            Else {

                $Chocolatey = Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

            }

        }

        Catch {

            Write-Verbose "Unable to install chocolatey on $Env:COMPUTERNAME."
            $Chocolatey = "Unable to install chocolatey on $Env:COMPUTERNAME."

        }

        Finally {

            Write-Output $Chocolatey

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}