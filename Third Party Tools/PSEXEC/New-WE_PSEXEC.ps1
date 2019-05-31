<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    PSEXEC PowerShell Module; will require the PSEXEC application to be included or processed in some way, will also be worthwhile to detect between 32 and 64 bit OS. 
    Recommend adding the entire Sysinternals suite to your "Path" environment variable so all Sysinternals tools can be called from a relative path.

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE


    Example 1: Copy Script to remote computer
    ----------------------------------------------------------
    Copy-Item -Path C:\temp\test.txt -Destination \\$Computer

    Example 2: Open Command Prompt on Remote Computer
    --------------------------------------------------
    $Env:Sysinternals\psexec.exe \\$Computer CMD

    Example 3: Run command prompt command on Remote Computer
    -----------------------------------------------------------------------------------------------------
    $Env:Sysinternals\psexec.exe \\$Computer CMD /c C:\Temp\ChromeStandaloneSetup32.exe /Silent /Install

    Example 4: Run PowerShell script via Command Prompt on Remote Computer
    ----------------------------------------------------------------------------
    $Env:Sysinternals\psexec.exe \\$Computer -i -s PowerShell C:\temp\test.ps1

    Example 5: Run SQL CMD command on remote computer
    ------------------------------------------------------------------------------------------------------------------------------
    $Env:Sysinternals\psexec.exe \\$Computer SQLCMD -S localhost -Q "BACKUP DATABASE [Master] TO DISK = "C:\Temp\$Computer.BAK""

    Example 6: Run SQL Script via SQL CMD on remote computer
    ---------------------------------------------------------------------------------
    $Env:Sysinternals\psexec.exe \\$Computer SQLCMD -s .\MSSQL -i "C:\temp\test.sql"

    Example 6: Regedit on remote computer
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $Env:Sysinternals\psexec.exe \\$Computer reg add HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy /t REG_SZ /d Restricted /f

.NOTES
    Author: Wesley Esterline
    Resources: 
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_pasteutm_campaign=growth
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
    $Computer = '0.0.0.0'
    $Computers = Get-Content C:\Temp\Test.txt
    $Drive = New-PSDrive -Name "ComputerName" -PSProvider FileSystem -Root "\\IPAddressorHostName\c$" -Credential Username
}

Process {

    Try {

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