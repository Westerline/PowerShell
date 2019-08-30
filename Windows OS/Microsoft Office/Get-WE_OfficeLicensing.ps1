Function Get-WE_OfficeLicensing {

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

    [CmdletBinding(SupportsShouldProcess)]

    Param(

        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS' -Force:$Force  -ErrorAction SilentlyContinue
            $ErrorActionPreference = Stop
            $ActivactionStatus = cscript.exe $OSPP.FullName /dstatus
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                OSPP              = $OSPP
                ActivactionStatus = $ActivactionStatus
            }

        }

        Catch {

            Write-Verbose "Unable to retrieve Microsoft Office activation status on $Env:COMPUTERNAME. Verify a path is available to OSPP.VBS."
            $Property = @{
                Status            = 'Unsuccessful'
                Computer          = $Env:COMPUTERNAME
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
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