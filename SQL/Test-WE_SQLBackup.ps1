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

}

Process {

    Try {
       
        Function Test-WE_SQLBackup ($FilePath) {
                          
            Invoke-Sqlcmd "Restore VERIFYONLY FROM DISK = '$FilePath'" -ErrorVariable BackupError -ErrorAction SilentlyContinue
            
            If ($BackupError -match 'VERIFY DATABASE is terminating abnormally') {

                Write-Host "Invalid Backup or an Unexpected Error Has Occurred." -ForegroundColor DarkRed -BackgroundColor DarkYellow
                $LocalBackupIntegrity = $False
            }

            Else {

                Write-Host "The backup set on file " -ForegroundColor DarkGreen -BackgroundColor Cyan
                $LocalBackupIntegrity = $False
                      
            }

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