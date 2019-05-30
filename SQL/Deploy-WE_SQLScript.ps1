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
    $Files = 'C:\temp\test.sql'
    $LogPath1 = 'C:\temp\Deploy-Tables_Check_SQL.log'

}

Process {

    $Test.GetEnumerator() | ForEach-Object {

        Try {
       
            $message = 'Querying {0} @ {1}...' -f $_.key, $_.value

            Write-Output $message

            $IP = $_.value

 


            Copy-Item $Files -Destination "\\$IP\c$\temp\test.sql" -Force  -ErrorAction Stop
        
            PSEXEC \\$IP -accepteula -nobanner SQLCMD -s .\MSSQL -i "C:\temp\test.sql" | Format-Table -AutoSize




            $Properties = [Ordered] @{
                Computer     = $_.key
                IP           = $_.value
                Availability = 'TRUE'
                Results      = $Results
            }


        }

        Catch [SpecificException] {
        
        }

        Catch {

            $message = 'Failed to connect to {0} @ {1}...' -f $_.key, $_.value

            Write-Output $message

            $IP = $_.value



            $Properties = [Ordered] @{
                Computer     = $_.key
                IP           = $_.value
                Availability = 'FALSE'
                Results      = 'NULL'
            }

        }

        Finally {

            (New-Object -TypeName PSObject -Property $Properties) | Out-File $LogPath1 -Append

        }
    
    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}