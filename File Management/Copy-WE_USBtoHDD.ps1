Start-Transcript 'C:\temp\test.txt'  -Append -Force



Try {



    $Drives = Get-WmiObject -class Win32_Logicaldisk | Select-Object -ExpandProperty DeviceiD

    Foreach ($Drive in $Drives) { 


        If (Test-Path -Path ($Drive + '\test')) {

            Set-Variable -Name USB_Drive -Value ($Drive) -Verbose -Force

        }

    }



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


}


Catch {

    Write-Warning 'A generic error has occured copying the test folder to the hard disk.' -Verbose

}



Stop-Transcript | Out-Null