<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Function to prase the output from the command line utility Robocopy.

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
    $Robo_Content = $null
    $Properties = $null
    $Robo_Formatted = $null

}

Process {

    Try {

        Function ConvertFrom-WE_RobocopyOutput {

            Param($File, $Robo_Computer, $LogPath)
   
            $Robo_Content = (Get-Content $File) -match '^(?= *?\b(Started|Total|Dirs|Files|Ended)\b)((?!    Files).)*$'
     
            Properties = [Ordered] @{
                $Computer = $Robo_Computer
                $Columns  = $Robo_Content[1] -replace '(?m)^\s+'
                $Dirs     = $Robo_Content[2] -replace 'Dirs :' -replace '(?m)^\s+'
                $Files    = $Robo_Content[3] -replace 'Files :' -replace '(?m)^\s+'
                $Started  = $Robo_Content[0] -replace 'Started :' -replace '(?m)^\s+'
                $Ended    = $Robo_Content[4] -replace 'Ended :' -replace '(?m)^\s+'
            }
                                
            $Robo_Formatted = New-Object -TypeName psobject -Property $Properties | Out-File -FilePath $LogPath -Append

        }
       
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