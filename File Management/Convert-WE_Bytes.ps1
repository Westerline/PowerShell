<#
.SYNOPSIS
    ...

.DESCRIPTION
    ...

.PARAMETER ParameterName
    ...

.Inputs

.Outputs

.EXAMPLE
    <Example goes here. Repeat this attribute for more than one example>

.NOTES
  Version: 1.0
  Author(s): Wesley Esterline
  Creation Date: 25/07/19
  Purpose/Change: Initial script development
  Resources: https://techibee.com/powershell/convert-from-any-to-any-bytes-kb-mb-gb-tb-using-powershell/2376
  To Do:
#>

Function Convert-WE_Bytes {

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

        [Parameter(Mandatory = $True)]
        [ValidateSet('B', 'KB', 'MB', 'GB', 'TB')]
        [String]
        $From,

        [Parameter(Mandatory = $True)]
        [ValidateSet('B', 'KB', 'MB', 'GB', 'TB')]
        [String]$To,

        [validatenotnullorempty()]
        [Int]$Precision = 4

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Val in $Value) {

            Try {

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


            }

            Catch {

                Write-Verbose "Unable to convert $Val to $To"
                $Math = 'Null'

            }

            Finally {

                Write-Output $Math$To

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}