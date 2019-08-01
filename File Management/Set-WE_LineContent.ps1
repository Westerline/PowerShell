<#
Pattern parameter will append wildcards to either side of the input.
#>

Function Set-WE_LineContent {

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('FileName')]
        [String[]]
        $Path,

        [Parameter(Mandatory = $True)]
        [validatenotnullorempty()]
        [String]
        $Pattern,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [validatenotnullorempty()]
        [String]
        $Value

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($P in $Path) {

            Try {

                $Content = Get-Content -Path $P
                $LineIndex = ($Content | Select-String -Pattern "$Pattern" | Select-Object -ExpandProperty LineNumber) - 1
                $Content[$LineIndex] = $Value
                Set-Content -Path $P -Value $Content
                $Property = @{
                    Path       = $P
                    NewContent = $Content[$LineIndex]
                }

            }

            Catch {

                Write-Verbose "Unable to get set line content for $P."
                $Property = @{
                    Path       = $P
                    NewContent = 'Null'
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