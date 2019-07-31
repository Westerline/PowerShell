<#
Example: Get-WE_DirectorySize -Directory (Get-ChildItem -Path C:\Users -Recurse -Directory | Select-Object -ExpandProperty FullName)
Example: Get-WE_DirectorySize -Directory (Get-ChildItem -Path C:\ -Directory | Select-Object -ExpandProperty FullName)
#>

Function Get-WE_DirectorySize {

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('Path')]
        [String[]]
        $Directory

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        ForEach ($Dir in $Directory) {

            Try {

                $Content = Get-ChildItem -Path $Dir -Recurse | Measure-Object -Property Length -Sum

                $Property = [Ordered] @{
                    Directory   = $Dir
                    'Size (MB)' = ($Content.Sum / 1MB -as [Int])
                }

            }

            Catch {

                Write-Verbose "Unable to get directory size for $Dir."
                $Property = [Ordered] @{
                    Directory   = $Dir
                    'Size (MB)' = 'Null'
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