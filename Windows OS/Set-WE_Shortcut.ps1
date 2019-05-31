<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    This is a more detailed description of the script. # The starting ErrorActionPreference will be saved and the current sets it to 'Stop'.

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE

    Example 1
    -------------------------------------------
    Set-Shortcut "C:\temp\.lnk" "C:\test.exe"

.NOTES
    Author: Wesley Esterline
    Resources: 
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
#>

Function Set-Shortcut {

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
            
            param ( [string]$SourceExe, [string]$ArgumentsToSourceExe, [string]$DestinationPath )
            $WshShell = New-Object -comObject WScript.Shell
            $Shortcut = $WshShell.CreateShortcut($DestinationPath)
            $Shortcut.TargetPath = $SourceExe
            $Shortcut.Arguments = $ArgumentsToSourceExe
            $Shortcut.Save()
            
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

}