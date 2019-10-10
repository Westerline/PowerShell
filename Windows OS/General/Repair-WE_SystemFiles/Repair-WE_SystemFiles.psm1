Function Repair-WE_SystemFiles {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
    sfc.exe Checks the integrity of any corrupted or missing protected system files with a known good version.
    The following Repair-WindowsImage parameters can be used to investigate image integrity issues in windows.
    The commands should be used in the follow order as per best practices:
        -CheckHealth (checks to see if any corruption exists)
        -ScanHealth (scans the Windows image for any corruption)
        -RestoreHealth (scans the Windows image for corruption and attempts repairs)

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
            -Add -Offline switch parameter to allow for repairing OS from a set of offline source files
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

    Param ( )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $sfc = sfc.exe /Scannow
            $CheckHealth = Repair-WindowsImage -CheckHealth
            $ScanHealth = Repair-WindowsImage -ScanHealth
            $RestoreHealth = Repair-WindowsImage -RestoreHealth
            $Property = @{
                sfc           = $sfc
                CheckHealth   = $CheckHealth
                ScanHealth    = $ScanHealth
                RestoreHealth = $RestoreHealth
            }

        }

        Catch {

            $Property = @{
                Status            = 'Unsuccessful'
                ComputerName      = $Env:COMPUTERNAME
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