<#
.DESCRIPTION
    PSEXEC PowerShell Module; will require the PSEXEC application to be included or processed in some way, will also be worthwhile to detect between 32 and 64 bit OS.
    Recommend adding the entire Sysinternals suite to your "Path" environment variable so all Sysinternals tools can be called from a relative path.
.EXAMPLE
    Example 1: Open Command Prompt on Remote Computer
    --------------------------------------------------
    & $PSScriptRoot\psexec.exe \\$ComputerName CMD

    Example 2: Silent Install on Remote Computer
    -----------------------------------------------------------------------------------------------------
    & $PSScriptRoot\psexec.exe \\$ComputerName CMD /c C:\Temp\ChromeStandaloneSetup32.exe /Silent /Install

    Example 3: Run PowerShell script via Command Prompt on Remote Computer
    ----------------------------------------------------------------------------
    & $PSScriptRoot\psexec.exe \\$ComputerName -s PowerShell C:\temp\test.ps1

    Example 4: Run SQL CMD command on remote computer
    ------------------------------------------------------------------------------------------------------------------------------
    & $PSScriptRoot\psexec.exe  \\$ComputerName SQLCMD -S localhost -Q "BACKUP DATABASE [Master] TO DISK = "C:\Temp\$ComputerName.BAK""

    Example 5: Run SQL Script via SQL CMD on remote computer
    ---------------------------------------------------------------------------------
    & $PSScriptRoot\psexec.exe  \\$ComputerName SQLCMD -S .\MSSQL -i "C:\temp\test.sql"

    Example 6: Regedit on remote computer
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------
    & $PSScriptRoot\psexec.exe  \\$ComputerName reg add HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy /t REG_SZ /d Restricted /f

.NOTES
    Author: Wesley Esterline
    Resources:
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_pasteutm_campaign=growth
    PS Tools available https://docs.microsoft.com/en-us/sysinternals/downloads/psexec
    Updated:
    To Do:
    Break each type of PSEXEC into its own module.
#>

Function Invoke-WE_PSEXEC {

    [Cmdletbinding(DefaultParameterSetname = 'Default',
        SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0,
            ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Installer')]
        [Parameter(ParameterSetName = 'PSScript')]
        [Parameter(ParameterSetName = 'SQLQuery')]
        [Parameter(ParameterSetName = 'SQLScript')]
        [Parameter(ParameterSetName = 'Regedit')]
        [ValidateNotNullOrEmpty()]
        [Alias('HostName')]
        [String[]]
        $ComputerName,

        [Parameter(Mandatory = $True,
            ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Installer')]
        [Parameter(ParameterSetName = 'PSScript')]
        [Parameter(ParameterSetName = 'SQLQuery')]
        [Parameter(ParameterSetName = 'SQLScript')]
        [Parameter(ParameterSetName = 'Regedit')]
        [ValidateSet('CMD', 'Installer', 'PowerShell', 'PSScript', 'SQLQuery', 'SQLScript', 'Regedit')]
        [String]
        $Type,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'Installer')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProgramPath,

        [Parameter(Mandatory = $False,
            ParameterSetName = 'Installer')]
        [String]
        $InstallationParameters,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'PSScript')]
        [ValidateNotNullOrEmpty()]
        [String]
        $PSScriptPath,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'SQLQuery')]
        [Parameter(ParameterSetName = 'SQLScript')]
        [ValidateNotNullOrEmpty()]
        [String]
        $SQLServer,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'SQLScript')]
        [ValidateNotNullOrEmpty()]
        [String]
        $SQLScriptPath,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'Regedit')]
        [ValidateNotNullOrEmpty()]
        [String]
        $RegKeyName,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'Regedit')]
        [ValidateNotNullOrEmpty()]
        [String]
        $RegKeyType,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'Regedit')]
        [ValidateNotNullOrEmpty()]
        [String]
        $RegValueName,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'Regedit')]
        [ValidateNotNullOrEmpty()]
        [String]
        $RegValueData

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Computer in $ComputerName) {

            Try {

                Switch ($Type) {

                    CMD { & $PSScriptRoot\psexec.exe \\$Computer CMD }
                    Installer { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer CMD /c $ProgramPath $InstallationParameters }
                    PowerShell { & $PSScriptRoot\psexec.exe \\$Computer PowerShell }
                    PSScript { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer -s PowerShell $PSScriptPath }
                    SQLQuery { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer SQLCMD -S $SQLServer -Q $SQLQuery }
                    SQLScript { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer SQLCMD -S $SQLServer -i $SQLScriptPath }
                    Regedit { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer reg add $RegKeyName /t $RegKeyType /v $RegValueName  /d $RegValueData }

                }

            }

            Catch {

                Write-Verbose "Unable to complete Invoke-WE_PSEXEC type $Type on $Computer"

            }

            Finally { }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}