<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    A hash table can be used to create a new object property based on an existing object property, useful for adjusting data to work as input for another commandlet. 
    Key1 value = The new name you want your property to have, this should match the required input of the commandlet you want to pipe into
    Key2 value = The existing object property you want to duplicate under a new name

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
       
        Import-Csv -Path test.txt | 
        Select-Object -Property *,
        @{Label = 'DesiredPropertyName1' ; Expression = { $_.DesiredObjectProperty1 } },
        @{Label = 'DesiredPropertyName2' ; Expression = { $_.DesiredObjectProperty2 } },
        @{Label = 'etc.' ; Expression = { $_.etc } }

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