<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Script will query all available drives and will detect the MDT USB drive based on if the deployment folder exists and the old folder exists.
    Once the folder has been detected, it will be copied over to the USB drive prior to imaging. This script also confirms whether or not the USB has enough free space for the folder.

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
    $Drives = Get-WmiObject -class Win32_Logicaldisk | Select-Object -ExpandProperty DeviceiD

}

Process {

    Try {      
      
        Foreach ($Drive in $Drives) { 

            If (Test-Path -Path ($Drive + '\test')) {

                Set-Variable -Name Old__Drive -Value ($Drive)

            }

            If (Test-Path -Path ($Drive + '\Deploy\Control')) {

                Set-Variable -Name USB_Drive -Value ($Drive)

            }

        }

        $USB_Drive_Free_Space = Get-WmiObject -Class Win32_Logicaldisk -Filter "DeviceID = '$USB_Drive'" | Select-Object -ExpandProperty FreeSpace

        $Old__Folder_Size = Get-ChildItem -Path ($Old__Drive + '\test') -Recurse | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum

        If ($USB_Drive) {

            $New_Drive_Free_Space = Get-WmiObject -Class Win32_LogicalDisk -Filter "VolumeName='Windows'" | Select-Object -ExpandProperty FreeSpace

            $USB_Folder_Size = Get-ChildItem -Path ($USB_Drive + '\test') -Recurse | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum



            If ($New_Drive_Free_Space -gt $USB_Folder_Size) {

                Write-Output "The new drive has enough space for..." -Verbose

                Copy-Item -Path "$USB_Drive\test" -Destination "$env:SystemDrive\test" -Recurse -Force -Verbose

                Remove-Item -Path "$USB_Drive\test" -Recurse -Force -Verbose

            }



            Elseif ($New_Drive_Free_Space -lt $USB_Folder_Size) {

                Write-Output "The New POS Drive does not have enough free space for the old..." -Verbose
            }

        }

        If ($USB_Drive_Free_Space -gt $Old__Folder_Size) {

            Write-Output "The USB Drive has enough free space for the old  folder." -Verbose

            Copy-Item -Path ($Old__Drive + '\test') -Destination ($USB_Drive + '\test') -Recurse -Force -Verbose

        }

        Elseif ($USB_Drive_Free_Space -lt $Old__Folder_Size) {

            Write-Warning 'The USB Drive does not have enough free space for the test folder.' -Verbose

        }

    }

    Catch [SpecificException] {
        
    }

    Catch {

        Write-Warning 'A generic error has occured copying the test folder to the USB drive.' -Verbose

    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null

}