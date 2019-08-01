Function Set-WE_OfficeProductKey {

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
            -Requires -runasadministrator

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = 'Product key must match the format XXXXX-XXXXX-XXXXX-XXXXX-XXXXX')]
        [ValidatePattern('\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w')]
        [ValidateNotNullOrEmpty()]
        [Alias('LicenseKey')]
        [String[]]
        $ProductKey

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS' -ErrorAction SilentlyContinue
            $ErrorActionPreference = Stop
            $ChangeKey = cscript.exe $OSPP.FullName /inpkey:$ProductKey
            $Activate = cscript.exe $OSPP.FullName /act
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                OSPP      = $OSPP
                ChangeKey = $ChangeKey
                Activate  = $Activate
            }

        }

        Catch {

            Write-Verbose "Unable to activate product key $ProductKey on $Env:COMPUTERNAME. Verify a path is available to OSPP.VBS."
            $Property = @{
                OSPP      = 'Null'
                ChangeKey = 'Null'
                Activate  = 'Null'
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Verbose $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}