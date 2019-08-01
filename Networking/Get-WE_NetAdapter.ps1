Function Get-WE_NetAdapter {

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
            -Add for loop to add multiple adapters + Index to hash table
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

    Param (

        [Parameter(Mandatory = $True,
            Position = 0)]
        [validateset('Ethernet', 'Wi-Fi', 'Bluetooth', 'Virtual')]
        [String]
        $Type

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'

            Switch ($Type) {

                Ethernet { $Adapter = Get-NetAdapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.3*' } }
                Wi-Fi { $Adapter = Get-NetAdapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.11*' } }
                Bluetooth { $Adapter = Get-NetAdapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Bluetooth*' } }
                Virtual { $Adapter = Get-NetAdapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Unspecified*' } }

            }

            $ErrorActionPreference = $StartErrorActionPreference

        }

        Catch {

            Write-Verbose "Unable to find $Type network adapter."
            $Adapter = "Unable to find $Type network adapter."

        }

        Finally {

            Write-Output $Adapter

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}