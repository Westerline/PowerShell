<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Load the assemblies and modules
    List the object properties, including the instance names.
    Enable the named pipes protocol for the default instance.

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
    Scriptname.ps1

    Description
    ----------
    This would be the description for the example.

.NOTES
    Author: Wesley Esterline
    Resources: Modified from the original script available at https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/dd206997(v=sql.105)
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

        Import-Module "sqlps" -DisableNamechecking
        [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
        [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")
        $smo = 'Microsoft.SqlServer.Management.Smo.'
        $wmi = New-Object ($smo + 'Wmi.ManagedComputer').
        $Wmi    
        $uri = "ManagedComputer[@Name='<computer_name>']/ ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Tcp']" 
        $Tcp = $wmi.GetSmoObject("$uri")
        $Tcp.IsEnabled = $true
        $Tcp.Alter()
        $Tcp
        $uri = "ManagedComputer[@Name='<computer_name>']/ ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Np']"
        $Np = $wmi.GetSmoObject("$uri")
        $Np.IsEnabled = $true
        $Np.Alter()
        $Np
        Restart-Service -Name MSSQLSERVER -Force -Verbose

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