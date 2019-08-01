<#
#>

Function Select-WE_IPString {

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $String

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($S in $String) {

            Try {

                $IPString = (Select-String -InputObject $S -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value

            }

            Catch {

                Write-Verbose "Unable to parse IP from string $S."
                $IPString = "Unable to parse IP from string $S."

            }

            Finally {

                Write-Output $IPString

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}