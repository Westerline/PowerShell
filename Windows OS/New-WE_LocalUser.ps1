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
    $Username = ______
    $FullName = ______
    $Description = _________
    $Password = Read-Host -AsSecureString

}

Process {

    Try {

        New-LocalUser -Name $Username -Password $Password -FullName $FullName -Description $Description -AccountNeverExpires $True -PasswordNeverExpires $True
        Add-LocalGroupMember -Group Administrators -Name $Username
    
    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}