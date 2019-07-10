<#
Used to find the exception name for errors. The exception name can be used in a catch [ErrorName] statement.
#>
Function Get-WE_ErrorName {

    Param (
        [Int] $ErrorIndex = 0
    )

    Begin { }

    Process {

        Try {

            $ErrorName = $error[$ErrorIndex]
            $Property = @{
                ErrorName = $ErrorName.exception.gettype().fullname
                Activity  = $ErrorName.CategoryInfo.Activity
            }
    
        }

        Catch { 

            Write-Verbose "Unable to capture Error Name"
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

    End { }
    
}