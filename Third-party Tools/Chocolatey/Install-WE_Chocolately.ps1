Param (
    [Switch] $Proxy
)

Begin { }

Process {

    Try {

        If ($Proxy.IsPresent) {
            [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }

        Else {
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }

    }

    Catch { }

    Finally { }

}

End { }