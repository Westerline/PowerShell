<#
Script will query all available drives and will detect the MDT USB drive based on if the deployment folder exists and the old folder exists.
Once the folder has been detected, it will be copied over to the USB drive prior to imaging. This script also confirms whether or not the USB has enough free space for the folder.
#>

Try { 
 
    $Drives = Get-WmiObject -class Win32_Logicaldisk | Select-Object -ExpandProperty DeviceiD

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



    If ($USB_Drive_Free_Space -gt $Old__Folder_Size) {

        Write-Output "The USB Drive has enough free space for the old  folder." -Verbose

        Copy-Item -Path ($Old__Drive + '\test') -Destination ($USB_Drive + '\test') -Recurse -Force -Verbose

    }


    Elseif ($USB_Drive_Free_Space -lt $Old__Folder_Size) {

        Write-Warning 'The USB Drive does not have enough free space for the test folder.' -Verbose

    }

}



Catch {

    Write-Warning 'A generic error has occured copying the test folder to the USB drive.' -Verbose

}