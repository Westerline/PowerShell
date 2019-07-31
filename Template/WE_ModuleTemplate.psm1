Function WE_ModuleTemplate {

    <#
.SYNOPSIS
    ...

.DESCRIPTION
    ...

.PARAMETER ParameterName
    ...

.Inputs

.Outputs
    <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

.EXAMPLE
    <Example goes here. Repeat this attribute for more than one example>

.NOTES
  Version: 1.0
  Author(s): Wesley Esterline
  Creation Date: <Date>
  Purpose/Change: Initial script development
  Resources:
  To Do:
#>

    #SupportsShouldProcess enables -whatif and -confirm parameters.
    [CmdletBinding()]

    <#
    For parameter sets, use: [Parameter(ParameterSetName = "Computer")]. To specify the parameter is part of multiple parameter sets, use:
        [Parameter(Mandatory=$false, ParameterSetName="Computer")]
        [Parameter(Mandatory=$true, ParameterSetName="User")]
    There are a number of useful Validate options for parameters:
        [ValidateCount(1,5)] can be used to validate the number of inputs for a parameter.
        [ValidatePattern("[0-9][0-9][0-9][0-9]")]
        [ValidateRange(0,10)]
        [ValidateScript( { })] returns true or false
        [ValidateSet("Low", "Average", "High")], these can also be dynamically generated from a Class at runtime.
            e.g. [System.ConsoleColor[]]$Color = [System.Enum]::GetValues([System.ConsoleColor]
        [ValidateDrive("C", "D", "Variable", "Function")]
        [ValidateUserDrive()]
        To use default values with the mandatory option, use [validatenotnullorempty()] instead.
    Switch parameters are easy to use and are preferred over Boolean parameters, which have a more difficult syntax.
    HelpMessage = "Help. Message. Here.",
            Position = 0)
    #>
    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Help. Message. Here.",
            Position = 0)]
        [ValidateNotNullOrEmpty()] 
        [Alias('Test')]
        [String[]] 
        $Parameter1
        
    )

    <#
    Parameter values can't be accessed within a begin block.
    Eg. Begin {Write-output "Test $Computername"} will only return "Test"
    #>
    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Computer in $ComputerName) {

            #Error Action should be set to Stop within the try block for non-terminating errors to be able to fall into the catch block.
            Try {
                
                $ErrorActionPreference = 'Stop'

                <#
                Instead of outputting two different object types, we're going to create a hash table of the properties we want from our two objects.
                Non-ordered hash tables are more memory efficient
                #>
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

            #Reset error action preference before beginning the next ForEach loop or ending the script.
            Finally {

                $ErrorActionPreference = $StartErrorActionPreference
                $Object = New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference 
    
    }

}