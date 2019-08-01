<#
Examples:  $FileName = Get-ChildItem -File -Path $Path | Where-Object { $_.VersionInfo.FileVersion -ne $Null }
#>

Function Get-WE_FileVersion {

    [CmdletBinding()]

    param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('FileName')]
        [String[]]
        $Path

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($P in $Path) {

            Try {

                $Item = Get-Item -Path $P -ErrorAction Stop
                $Property = @{
                    FullName    = $Item.FullName
                    FileVersion = $Item.VersionInfo.FileVersion
                }

            }

            Catch {

                Write-Verbose "Unable to get file version for $P."
                $Property = @{
                    FullName    = $P
                    FileVersion = 'Null'
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