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
    Example CSV column names are Number, Username, and Password

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
    $ConnectionDetails = Import-Csv -Path C:\Temp\Test.txt

}

Process {
    
    Foreach ($ConnectionDetail in $ConnectionDetails) {
        
        Try {
        
            $IP = $ConnectionDetail.Number
            $Username = $ConnectionDetail.Username
            $Password = $ConnectionDetail.Password
            $LocalGroup = 'Test'
            Write-Host "Adding $ConnectionDetail.Number"
            & cmdkey /add:$IP /user:($UserName) /pass:$Password
            & net localgroup $LocalGroup $Username /Add
            Write-Host ""

        }

        Catch [SpecificException] {
            
        }

        Catch {

            Write-Host "$ConnectionDetail.Number connection failed."

        }

        Finally {

        }

    }

}