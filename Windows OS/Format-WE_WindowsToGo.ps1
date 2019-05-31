<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Macrium Reflect Options
    #Restore Tab > Browse for an image file > Select image file
    #Restore only the Windows partition to just the W: partition on the new hard drive
    #Select "Restore Partition Properties" > Click [Maximum size] > Allocate Drive Letter: W
    #Next > Advanced Options > MBR Options > Click [Do not replace]

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
       
        $FriendlyName = "asmedia ASMT1153e"

        $WINTOGO_Drive = Get-Disk | Where-Object { ($_.FriendlyName -eq $FriendlyName) -and ($_.size -ge 500gb) } | Select-Object -ExpandProperty Number

        Write-Output Windows To Go hard drive detected.

        Write-Output Creating partition scheme on disk

        Initialize-Disk -Number $WINTOGO_Drive -PartitionStyle MBR

        New-Partition -DiskNumber $WINTOGO_Drive -Size 350MB -DriveLetter 'S' -IsActive

        Format-Volume -DriveLetter 'S' -FileSystem FAT32 -NewFileSystemLabel "System"

        New-Partition -DiskNumber $WINTOGO_Drive -UseMaximumSize -DriveLetter 'W'

        Format-Volume -DriveLetter 'W' -FileSystem NTFS -NewFileSystemLabel "Windows To Go"

        bcdboot W:\Windows /s S: /f ALL

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