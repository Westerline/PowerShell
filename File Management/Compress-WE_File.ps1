<#
.SYNOPSIS
    Sends selected files to compressed archive.

.DESCRIPTION
    Sends selected files to compressed archive and gets the file size in an easily readiable format such as megabytes, gigabytes, etc.

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
    $Date = (Get-Date).Day, - (Get-Date).Month, - (Get-Date).Year

}

Process {

    Try {
       
        Get-ChildItem -Recurse -Path C:\InfinityTools\Backups | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Compress-Archive -CompressionLevel Optimal -DestinationPath "C:\temp\($Date).zip" -Force

        Get-ChildItem -Path C:\temp | Select-Object -Property @{N = 'FriendlySize'; E = { ConvertFrom-Bytes $_.Length } } >> C:\temp\ArchiveSize.txt

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