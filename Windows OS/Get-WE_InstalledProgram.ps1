<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Step 1: Define the variable to hold the location of Currently Installed Programs
    Step 2: Create an instance of the Registry Object and open the HKLM base key
    Step 3: Drill down into the Uninstall key using the OpenSubKey Method
    Step 4: Retrieve an array of string that contain all the subkey names
    Step 5: Open each Subkey and use GetValue Method to return the required values for each

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
    $Path = "C:\temp\test.txt"
    $Computers = Import-Csv $Path\test.csv

}

Process {

    Try {

        $Array = @()

        foreach ($Computer in $Computers) {

            $Computername = $pc.Computername
            $UninstallKey = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 
            $reg = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine', $Computername) 
            $regkey = $reg.OpenSubKey($UninstallKey) 
            $subkeys = $regkey.GetSubKeyNames() 

            foreach ($key in $subkeys) {

                $thisKey = $UninstallKey + "\\" + $key 
                $thisSubKey = $reg.OpenSubKey($thisKey) 
                $Object = New-Objectect PSObjectect
                $Object | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $Computer
                $Object | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))
                $Object | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))
                $Object | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($thisSubKey.GetValue("InstallLocation"))
                $Object | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($thisSubKey.GetValue("Publisher"))
                $Array += $Object

            } 

        }

        $Array | Where-Object { $_.DisplayName } | Select-Object ComputerName, DisplayName, DisplayVersion, Publisher | ft -auto | Out-File "C:\temp\Test.txt"

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