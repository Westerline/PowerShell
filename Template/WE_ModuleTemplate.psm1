Function WE_ModuleTemplate {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

        <CommonParameters>
            This cmdlet supports the common parameters: Verbose, Debug,
            ErrorAction, ErrorVariable, WarningAction, WarningVariable,
            OutBuffer, PipelineVariable, and OutVariable. For more information, see
            about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -
        To Do:
            -
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

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
        $ComputerName

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

                $Property = @{
                    Stauts            = 'Disconnected'
                    Computername      = $Computer
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                }

            }

            #Reset error action preference before beginning the next ForEach loop or ending the script.
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