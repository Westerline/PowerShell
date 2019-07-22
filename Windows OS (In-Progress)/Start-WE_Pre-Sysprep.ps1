<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    

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
    To Do: Translate to PowerShell Script to run prior to using sysprep on a VM image build
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
       
        & vssadmin delete shadows /All /Quiet
        Remove-Item c:\Windows\SoftwareDistribution\Download\*.* /f /s /q
        Remove-Item %windir%\$NT* /f /s /q /a:h
        Remove-Item c:\Windows\Prefetch\*.* /f /s /q
        c:\windows\system32\cleanmgr /sagerun:1
        & wevtutil el 1>%Temp%\cleaneventlog.txt
        for /f %%x in (%Temp%\cleaneventlog.txt) do wevtutil cl %%x
        Remove-Item %Temp%\cleaneventlog.txt
        ipconfig /flushdns

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