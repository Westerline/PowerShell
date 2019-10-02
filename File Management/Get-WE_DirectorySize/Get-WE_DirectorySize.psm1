Function Get-WE_DirectorySize {

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
            -Add option to enumerate through all sub-directories and get their size as well.
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>Get-WE_DirectorySize -Directory (Get-ChildItem -Path C:\Users -Recurse -Directory | Select-Object -ExpandProperty FullName)

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('Directory')]
        [String[]]
        $Path,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [validatenotnullorempty()]
        [Int]
        $Precision = 2,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        ForEach ($P in $Path) {

            Try {

                $Content = Get-ChildItem -Path $P -Recurse -Force:$Force -ErrorAction Stop | Measure-Object -Property Length -Sum
                $Property = @{
                    Directory = $P
                    SizeMB    = [Math]::Round($Content.Sum / 1MB, $Precision, [MidPointRounding]::AwayFromZero)
                }

            }

            Catch {

                Write-Verbose "Unable to get directory size for $P."
                $Property = [Ordered] @{
                    Status            = 'Unsuccessful'
                    Directory         = $P
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