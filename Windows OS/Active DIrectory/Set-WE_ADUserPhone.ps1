<#
Requires GroupPolicy Module
#>

[CmdletBinding()]

Param (

    [Parameter(Mandatory = $False)]
    [Alias('Transcript')]
    [string]$TranscriptFile

)

Begin {
    Start-Transcript $TranscriptFile  -Append -Force
    $StartErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'
    Get-ADUser -Filter * -Properties * | Export-Csv C:\Temp\ADUsers_BAK.csv -Force

}

Process {

    Try {

        Foreach ($user in (import-csv "c:\temp\test.csv")) {
            $DisplayName = Get-ADUser -Filter "(DisplayName -eq '$($user.DisplayName)')"
            $DisplayName | Set-ADUser -MobilePhone $User.MobilePhone -Verbose
            $DisplayName | Set-ADUser -HomePhone $User.HomePhone -Verbose
            $DisplayName | Set-ADUser -OfficePhone $User.OfficePhone -Verbose
        }

    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

        Get-ADUser -Filter * -Properties TelephoneNumber, MobilePhone, HomePhone, OfficePhone | Select-Object -Property Name, TelephoneNumber, MobilePhone, HomePhone, OfficePhone

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}