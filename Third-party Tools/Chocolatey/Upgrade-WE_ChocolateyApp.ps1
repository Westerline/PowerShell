<#
.Notes
    To Do: (1) Add support for --except option to exclude certain upgrades. (2) Parsing of C:\ProgramData\chocolatey\logs\chocolatey.log (3) Support for choco --proxy parameter
#>

Param (
    [Switch] $Proxy
)

Begin { }

Process {

    Try {

        If ($Proxy.IsPresent) {
            [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; Choco Upgrade All --install-if-not-installed -Y 
        }

        Else {
            Choco Upgrade All --install-if-not-installed -Y
        }

    }

    Catch { }

    Finally { }

}

End { }