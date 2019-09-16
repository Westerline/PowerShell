Function Ping-WE_Subnet {

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
            -Set NetworkAddress Parameter to IP type.
            -Create Subnet Calculator Tool
            -Tie calculator to ping script
            -Scan range based on subnet mask
            -Redirect warning output to $Property variable and remove -InformationLevel parameter
            -Fix parameter input on $Range. Doesn't accept 1..10 as input
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NetworkAddress = '192.168.1',

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateRange(0, 255)]
        [Int]
        $Range = 1..40

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($R in $Range) {

            Try {

                $Ping = Test-NetConnection -ComputerName "$NetworkAddress.$R" -WarningAction SilentlyContinue -InformationLevel Quiet -ErrorAction Stop
                $Property = @{
                    ComputerName  = "$NetworkAddress.$R"
                    PingSucceeded = $Ping
                }

            }

            Catch {

                Write-Output "Unable to ping subnet $NetworkAddress in range $Range"
                $Property = @{
                    Status            = 'Unsuccessful'
                    ComputerName      = "$NetworkAddress.$R"
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
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