<#
.SYNOPSIS
    Updates phone number fields for AD users including home, mobile, and office.
.DESCRIPTION
    Updates phone number fields for AD users including home, mobile, and office.

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
    Scriptname.ps1

    Description
    ----------
    This would be the description for the example.

.NOTES
    Author: Wesley Esterline
    Resources: 
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
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