Function Get-WE_Win32Class {

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
            -format output of property and method arrays to be more readable
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

    Param ()

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $Win32Classes = Get-CimClass -ClassName '*Win32*' -ErrorAction Stop

        }

        Catch {

            Write-Verbose "Unable to fetch Win32 classes on $Env:COMPUTERNAME."
            $Win32Classes = "Unable to fetch Win32 classes on $Env:COMPUTERNAME."

        }

        Finally {

            Write-Output $Win32Classes

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}