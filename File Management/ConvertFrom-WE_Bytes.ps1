<#
.SYNOPSIS
    Converts from bytes to KB, MB, GB etc.

.DESCRIPTION
    Gets the file size in an easily readiable format such as kilobytes, megabytes, gigabytes, etc.

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
    Get-ChildItem -Path C:\temp\temp.zip | Select-Object -Property Name, LastWriteTime, @{N='FriendlySize';E={ConvertFrom-WE_Bytes -Bytes $_.Length}}

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

        function ConvertFrom-WE_Bytes {
            param($Bytes)
            $sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
            for ($i = 0; ($Bytes -ge 1kb) -and 
                ($i -lt $sizes.Count); $i++) { $Bytes /= 1kb }
            $N = 2; if ($i -eq 0) { $N = 0 }
            "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
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