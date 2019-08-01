<#
#>

Function Test-WE_StringNumeric {

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
                    String  = "$Str"
                    Numeric = 'Null'
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