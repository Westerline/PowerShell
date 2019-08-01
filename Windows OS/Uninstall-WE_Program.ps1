Function Uninstall-WE_Program {

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
            -
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('ProgramName')]
        [String[]] $Name

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($N in $Name) {

            Try {

                $ErrorActionPreference = 'Stop'
                $Program = Get-WE_InstalledProgram | Where-Object { $_.DisplayName -eq "$N" }
                $UninstallString = $Program.UninstallString -Replace "msiexec.exe", "" -Replace "/I", "" -Replace "/X", ""
                $UninstallArgument = $UninstallString.Trim()
                $UninstallCommand = Start-Process "msiexec.exe" -arg "/X $UninstallArgument /qb" -Wait
                $ErrorActionPreference = $StartErrorActionPreference
                $Property = @{
                    Status           = 'Successful'
                    UninstallCommand = $UninstallCommand
                }

            }

            Catch {

                Write-Verbose "Unable to uninstall the program $N."
                $Property = @{
                    Status           = 'Unsuccessful'
                    UninstallCommand = 'Null'
                }

            }

            Finally {

                New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}