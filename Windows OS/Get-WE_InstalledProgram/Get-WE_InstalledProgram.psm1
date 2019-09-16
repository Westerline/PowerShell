Function Get-WE_InstalledProgram {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

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
            - Custom Format File for alphabetical sorting of output
            -Select default properties in output PS Module Manifest
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [Cmdletbinding()]

    Param ( )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $OSArchitecture = Get-WmiObject -Class WIn32_OperatingSystem | Select-Object -ExpandProperty OSArchitecture

            If ($OSArchitecture -eq '64-bit') {

                $x64Program = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -ne $Null }
                $x86Program = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -ne $Null }
                $AllPrograms = Compare-Object -Property DisplayName -ReferenceObject $x64Program -DifferenceObject $x86Program -IncludeEqual -PassThru

            }

            Elseif ($OSArchitecture -eq '32-bit') {

                $AllPrograms = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -ne $Null }

            }

            $ErrorActionPreference = $StartErrorActionPreference

        }

        Catch {

            Write-Verbose "Unable to fetch installed programs on $Env:COMPUTERNAME. Please ensure you have administrator access to the registry and try running the cmdlet again."
            $AllPrograms = @{
                Status            = 'Unsuccessful'
                ComputerName      = $Env:COMPUTERNAME
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
            }

        }

        Finally {

            Write-Output $AllPrograms

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}