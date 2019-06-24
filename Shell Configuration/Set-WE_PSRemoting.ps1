<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Remote Endpoint Configuration
    Step 1: Local Account Token
    Step 2: Enable-PSRemoting
    Step 3: Enable Legacy HTTP Listener on Port 80 (Optional)
    Client-side
    Configure the machines you the client can remote to.

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
    Scriptname.ps1

    Description
    ----------
    Example Non-domain Connection

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

}

Process {

    Try {       

        Enable-PsRemoting -Force

        Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener -value True  

        Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.10.10.3"

        Set-Item WSMan:\localhost\Client\TrustedHosts -Value "PC4" -Concatenate
 
        $SERVER = 'REMOTE_SERVER'

        $USER = 'REMOTE_USER'

        New-PSSession -ComputerName $Server -Name 'PC3' -Credential (get-credential "$USER") -Port 80

        Enter-PSSession -ComputerName $SERVER

        Invoke-Command -Computer $SERVER -Credential (get-credential "$USER") { Get-ChildItem C:\ } -port 80

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