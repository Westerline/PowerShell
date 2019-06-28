Function New-ModuleTemplate {

    <#
.SYNOPSIS
    ...

.DESCRIPTION
    ...

.PARAMETER UseExitCode
    ...

.EXAMPLE
    Example 1
    ----------
    Description for the example

.NOTES
    Author: Wesley Esterline
    Resources: Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
    To-Do: 
#>

    [CmdletBinding()]

    Param (

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'

    }

    Process {

        Foreach ($Computer in $ComputerName) {

            Try {
            
                $Property = @{
                
                    Computername = $ComputerName
                    Stauts       = 'Connected'
                    Property1    = $Property1
                    Property2    = $Property2
                    Property3    = $Property3

                }
       
            }

            Catch {
                Write-Verbose "Error occurred with $Computer..."

                $Property = @{

                    Computername = $ComputerName
                    Stauts       = 'Connected'
                    Property1    = 'Null'
                    Property2    = 'Null'
                    Property3    = 'Null'

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