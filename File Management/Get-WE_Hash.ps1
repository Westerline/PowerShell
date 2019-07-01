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
       
        Write-Output "Please enter the full path to the file you'd like to Hash check, surrounded by double quotes (`")"
        $InputFile = Read-Host

        $SHA1 = Get-FileHash -Path $InputFile -Algorithm SHA1
        $SHA256 = Get-FileHash $InputFile -Algorithm SHA256
        $SHA384 = Get-FileHash $InputFile -Algorithm SHA384
        $SHA512 = Get-FileHash $InputFile -Algorithm SHA512
        $MACTripleDES = Get-FileHash $InputFile -Algorithm MACTripleDES
        $MD5 = Get-FileHash $InputFile -Algorithm MD5
        $RIPEMD160 = Get-FileHash $InputFile -Algorithm RIPEMD160

        $Properties = [Ordered] @{File = $InputFile
            SHA1                      = $SHA1.Hash
            SHA256                    = $SH256.Hash
            SHA384                    = $SHA384.Hash
            SHA512                    = $SHA512.Hash
            MACTripleDES              = $MACTripleDES.Hash
            MD5                       = $MD5.Hash
            RIPEMD160                 = $RIPEMD160.Hash
        }

        New-Object -TypeName PSObject -Property $Properties | Out-Host

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