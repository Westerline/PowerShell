<#
Used to find the exception name for errors. The exception name can be used in a catch [ErrorName] statement.
#>
Function Get-WE_ErrorName {

    [Cmdletbinding()]

    Param (

        [ValidateNotNullOrEmpty()]
        [Int[]]
        $ErrorIndex = 0

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($E in $ErrorIndex) {

            Try {

                $ErrorName = $Error[$E]
                $Property = @{
                    ErrorName = $ErrorName.exception.gettype().fullname
                    Activity  = $ErrorName.CategoryInfo.Activity
                }

            }

            Catch {

                Write-Verbose "Unable to capture error name. PLease try re-creating the error and rerunning this cmdlet."
                $Property = @{
                    ErrorName = 'Null'
                    Activity  = 'Null'
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