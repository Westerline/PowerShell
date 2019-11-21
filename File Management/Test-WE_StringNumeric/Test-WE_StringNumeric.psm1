Function Test-WE_StringNumeric {

    <#

    .SYNOPSIS
        Tests whether or not a string contains only integer characters.

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

    [CmdletBinding()]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('Pattern')]
        [String[]]
        $String

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Str in $String) {

            Try {

                $ErrorActionPreference = 'Stop'
                $Boolean = "$Str" -match "^[\d\.]+$"
                $ErrorActionPreference = $StartErrorActionPreference
                $Property = @{
                    String  = "$Str"
                    Numeric = "$Boolean"
                }

            }

            Catch {

                Write-Verbose "Unable to analyze the string $Str."
                $Property = @{
                    Status            = 'Unsuccessful'
                    String            = "$Str"
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