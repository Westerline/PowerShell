<#
Example: Get-WE_DirectorySize -Directory (Get-ChildItem -Path C:\Users -Recurse -Directory | Select-Object -ExpandProperty FullName)
Example: Get-WE_DirectorySize -Directory (Get-ChildItem -Path C:\ -Directory | Select-Object -ExpandProperty FullName)
#>

FUnction Get-WE_DirectorySize {
    
    Param (

        [String[]] $Directory 

    )

    Begin {
        
        $ErrorActionPreference = 'Stop'

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

    End { }

}