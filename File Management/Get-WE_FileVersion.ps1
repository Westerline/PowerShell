Function Get-WE_FileVersion {

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

        C:\PS>Get-WE_FileVersion -Path (Get-ChildItem -File -Path $Path | Where-Object { $_.VersionInfo.FileVersion -ne $Null })

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding()]

    param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('FileName')]
        [String[]]
        $Path,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($P in $Path) {

            Try {

                $Item = Get-Item -Path $P -Force -ErrorAction Stop
                $Property = @{
                    FullName    = $Item.FullName
                    FileVersion = $Item.VersionInfo.FileVersion
                }

            }

            Catch {

                Write-Verbose "Unable to get file version for $P."
                $Property = @{
                    Status            = 'Unsuccessful'
                    FullName          = $P
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