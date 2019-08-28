Function Invoke-WE_PSEXEC {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        PSEXEC PowerShell Module; will require the PSEXEC application to be included or processed in some way, will also be worthwhile to detect between 32 and 64 bit OS.
        Recommend adding the entire Sysinternals suite to your "Path" environment variable so all Sysinternals tools can be called from a relative path.

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

        <CommonParameters>
            This cmdlet supports the common parameters: Verbose, Debug,
            ErrorAction, ErrorVariable, WarningAction, WarningVariable,
            OutBuffer, PipelineVariable, and OutVariable. For more information, see
            about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -
        To Do:
            -Break each type of PSEXEC into its own module.
            -Include PSEXEC as part of the module folder.
        Misc:
            -PS Tools available https://docs.microsoft.com/en-us/sysinternals/downloads/psexec

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>Invoke-WE_PSEXEC -ComputerName Computer1 -Type CMD

        Description

        -----------

        Open Command Prompt on remote computer.

        -------------------------- EXAMPLE 2 --------------------------

        C:\PS>Invoke-WE_PSEXEC -ComputerName Computer1 -Type Installer -ProgramPath 'C:\Temp\ChromeStandaloneSetup32.exe' -InstallationParameters /Silent /Install


        Description

        -----------

        Install application on remote computer.

        -------------------------- EXAMPLE 3 --------------------------

        C:\PS>Invoke-WE_PSEXEC -ComputerName Computer1 -Type PSScript -PSScriptPath 'C:\temp\test.ps1'

        Description

        -----------

        Run PowerShell script via Command Prompt on remote computer.

        -------------------------- EXAMPLE 4 --------------------------

        C:\PS>Invoke-WE_PSEXEC -ComputerName Computer1 -Type SQLQuery -SQLServer localhost -Query "BACKUP DATABASE [Master] TO DISK = "C:\Temp\$ComputerName.BAK""

        Description

        -----------

        Run SQL CMD command on remote computer.

        -------------------------- EXAMPLE 5 --------------------------

        C:\PS>Invoke-WE_PSEXEC -ComputerName Computer1 -Type SQLCMD -SQLServer LocalHost -SQLScriptPath "C:\temp\test.sql"

        Description

        -----------

        Run SQL Script via SQL CMD on remote computer.

        -------------------------- EXAMPLE 6 --------------------------

        C:\PS>Invoke-WE_PSEXEC -ComputerName Computer1 -Type Regedit -RegKey "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -RegValueName ExecutionPolicy -RegValueType REG_SZ -RegValueData "Restricted /f"

        Description

        -----------

        Regedit on remote computer.

    #>

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
            ParameterSetName = 'SQLQuery')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Query,

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
        $RegKey,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            ParameterSetName = 'Regedit')]
        [ValidateSet('REG_SZ', 'REG_MULTI_SZ', 'REG_DWORD_BIG_ENDIAN', 'REG_DWORD', 'REG_BINARY', 'REG_DWORD_LITTLE_ENDIAN', 'REG_LINK', 'REG_FULL_RESOURCE_DESCRIPTOR', 'REG_EXPAND_SZ')]
        [String]
        $RegValueType,

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

                $ErrorActionPreference = 'Stop'

                Switch ($Type) {

                    CMD { & $PSScriptRoot\psexec.exe \\$Computer CMD }
                    Installer { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer CMD /c $ProgramPath $InstallationParameters }
                    PowerShell { & $PSScriptRoot\psexec.exe \\$Computer PowerShell }
                    PSScript { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer -s PowerShell $PSScriptPath }
                    SQLQuery { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer SQLCMD -S $SQLServer -Q $Query }
                    SQLScript { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer SQLCMD -S $SQLServer -i $SQLScriptPath }
                    Regedit { & $PSScriptRoot\psexec.exe /accepteula /nobanner \\$Computer reg add $RegKey /t $RegValueType /v $RegValueName  /d $RegValueData }

                }

                $ErrorActionPreference = $StartErrorActionPreference

            }

            Catch {

                Write-Verbose "Unable to complete Invoke-WE_PSEXEC type $Type on $Computer"
                $Property = @{
                    Status            = 'Unsuccessful'
                    PSEXECType        = $Type
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                }

            }

            Finally {

                $Object = New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}