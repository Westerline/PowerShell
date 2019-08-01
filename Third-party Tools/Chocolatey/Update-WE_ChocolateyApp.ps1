<#
.Notes
    To Do: (1) Add support for --except option to exclude certain upgrades. (2) Parsing of C:\ProgramData\chocolatey\logs\chocolatey.log (3) Support for choco --proxy parameter
#>

Function Update-WE_ChocolateyApp {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Switch] $Proxy

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'

            If ($Proxy.IsPresent) {

                [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; chocolatey.exe Upgrade All --install-if-not-installed -Y

            }

            Else {

                $Chocolatey = chocolatey.exe Upgrade All --install-if-not-installed -Y

            }

            $ErrorActionPreference = $StartErrorActionPreference

        }

        Catch {

            Write-Verbose "Unable to upgrade chocolatey applications on $Env:COMPUTERNAME. Please verify that chocolatey is installed and that you are able to reach the target repository."
            $Chocolatey = "Unable to upgrade chocolatey applications on $Env:COMPUTERNAME. Please verify that chocolatey is installed and that you are able to reach the target repository."

        }

        Finally {

            Write-Output $Chocolatey

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}