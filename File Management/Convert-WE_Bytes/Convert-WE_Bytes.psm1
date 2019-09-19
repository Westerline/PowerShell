Function Convert-WE_Bytes {

    <#

    .SYNOPSIS
        Converts bytes to kilobytes, megabytes, etc. or vice versa.

    .DESCRIPTION
        This command can convert any of the following byte sizes to one another: (bytes, kilobytes, megabytes, gigabytes, terabytes).

    .PARAMETER
        -ComputerName [<String[]>]
            Test parameter for computer names.

            'Test' is an available alias.

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
        System.Double[], System.Integer, System.String
            You can pipe a Double type object to Convert-WE_Bytes.

    .OUTPUTS
        System.String

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -Modified from: https://techibee.com/powershell/convert-from-any-to-any-bytes-kb-mb-gb-tb-using-powershell/2376
        To Do:
            -
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS> Convert-WE_Bytes -Value 10000000000000 -From B -To KB

        Description

        -----------

        This command converts a value in bytes to kilobytes.

    #>

    [cmdletbinding()]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('Size')]
        [Double[]]
        $Value,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [ValidateSet('B', 'KB', 'MB', 'GB', 'TB')]
        [String]
        $From,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 2)]
        [ValidateSet('B', 'KB', 'MB', 'GB', 'TB')]
        [String]
        $To,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [validatenotnullorempty()]
        [Int]
        $Precision = 4

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Val in $Value) {

            Try {

                $ErrorActionPreference = 'Stop'

                Switch ($From) {

                    'B' { $Val = $Val }
                    'KB' { $Val = $Val * 1000 }
                    'MB' { $Val = $Val * 1000000 }
                    'GB' { $Val = $Val * 1000000000 }
                    'TB' { $Val = $Val * 1000000000000 }

                }

                Switch ($To) {

                    'B' { $Val = $Val }
                    'KB' { $Val = $Val / 1000 }
                    'MB' { $Val = $Val / 1000000 }
                    'GB' { $Val = $Val / 1000000000 }
                    'TB' { $Val = $Val / 1000000000000 }

                }

                $Math = [Math]::Round($Val, $Precision, [MidPointRounding]::AwayFromZero)
                $ErrorActionPreference = $StartErrorActionPreference
                $Property = @{
                    Value = $Math
                    Unit  = $To
                }

            }

            Catch {

                Write-Verbose "Unable to convert $Val to $To"
                $Property = @{
                    Status            = 'Unsuccessful'
                    Value             = $Val
                    To                = $To
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                }

            }

            Finally {

                Write-Output $Property

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}