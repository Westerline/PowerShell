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
    $Computers = Get-Content 
}

Process {

    Try {
        Foreach ($Computer in $Computers) {

            Test-NetConnection $Computer -CommonTCPPort HTTP | Out-File -FilePath 'C:\temp\PSRemote_BOS.txt' -Append



            $PortQry = Set-location '.\Utilities\Sysinternals\PortQryUI'
            $OutputFile = '.\Log\NZP-Test_Octgn\'

            #DNS#
            .\PortQry.exe -n 0.0.0.0 -p UDP -e 53 -l "$OutputFile\DNS_1.log"
            #####



            #HTTP#
            .\PortQry.exe -n hostname.com -p TCP -e 80 -l "$OutputFile\HTTP_1.log"
            ######



            #FTP#
            .\PortQry.exe -n hostname -p TCP -e 20, 21 -l "$OutputFile\FTP_1.log"
            #####
                    
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