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

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validateset('Ethernet', 'Wi-Fi', 'Bluetooth', 'Virtual', 'All')]
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

                Ethernet { $Object = Get-NetAdapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.3*' } }
                Wi-Fi { $Object = Get-NetAdapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.11*' } }
                Bluetooth { $Object = Get-NetAdapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Bluetooth*' } }
                Virtual { $Object = Get-NetAdapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Unspecified*' } }
                All { $Object = Get-NetAdapter -IncludeHidden }
                Default { $Object = Get-NetAdapter -IncludeHidden }

            }

            $ErrorActionPreference = $StartErrorActionPreference

        }

        Catch {

            Write-Verbose "Unable to find $Type network adapter."
            $Object = @{
                Status            = 'Unsuccessful'
                AdapterType       = $Type
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
            }

        }

        Finally {

            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}