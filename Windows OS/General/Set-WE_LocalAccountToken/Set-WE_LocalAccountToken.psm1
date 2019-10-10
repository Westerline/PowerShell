Function Set-WE_LocalAccountToken {

    <#

    .SYNOPSIS
        Create Registry Value for Remote File Share and PSEXEC

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
            -Set to 1 for Disable (no remote admin share allowed), Set to 0 for Enable (remote admin share allowed).
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $LocalAccountTokenFilterPolicy = New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'  -Name LocalAccountTokenFilterPolicy -Value 1 -PropertyType Dword -Force:$Force -ErrorAction Stop
            $Property = @{
                LocalAccountTokenFilterPolicy = $LocalAccountTokenFilterPolicy
            }

        }

        Catch {

            Write-Verbose "Unable to set local account token filter policy on $Env:COMPUTERNAME."
            $Property = @{
                Status            = 'Unsuccessful'
                ComputerName      = $Env:CommonProgramFiles
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}