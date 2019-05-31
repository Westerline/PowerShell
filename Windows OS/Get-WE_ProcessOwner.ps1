<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    This is a more detailed description of the script. # The starting ErrorActionPreference will be saved and the current sets it to 'Stop'.

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
    $Computers = 'Test'
    $Credentials = (Get-Credential -Message 'Please enter the required credentials.')
}

Process {

    Invoke-Command -Session $Sessions -ScriptBlock {

        Try {
        
            $Process = Get-WmiObject -Class Win32_Process -Filter "Name like '%Test%'"

            $Name = $Process.Name

            $Owner = $Process.GetOwner() | Select-Object -ExpandProperty User
    
            Write-Output "", "$Env:Computername is running $Name with the owner $Owner", ""
        }

        Catch [SpecificException] {
        
        }

        Catch {


        }

        Finally {

        }

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
    Remove-PSSession -Session $Sessions
}