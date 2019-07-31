<#
Examples:  $FileName = Get-ChildItem -File -Path $Path | Where-Object { $_.VersionInfo.FileVersion -ne $Null }
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
    $Path

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Foreach ($File in $Path) {

        Try {

            $Property = @{
                FullName    = $File.FullName
                FileVersion = $File.VersionInfo.FileVersion
            }

        }

        Catch {

            Write-Verbose "Unable to get file version for $File."
            $Property = @{
                FullName    = $File
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