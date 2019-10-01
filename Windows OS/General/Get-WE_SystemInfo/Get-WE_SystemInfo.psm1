Function Get-WE_SystemInfo {

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

    [CmdletBinding()]

    param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [Alias('HostName', 'CN')]
        [ValidateNotNullOrEmpty()]
        [String[]]$ComputerName

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        ForEach ($Computer in $ComputerName) {

            Try {

                $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
                $OS = Get-CimInstance -CimSession $Session -ClassName Win32_OperatingSystem
                $CS = Get-CimInstance -CimSession $Session -ClassName Win32_ComputerSystem

                $Property = @{Computername = $ComputerName
                    Stauts                 = 'Connected'
                    SPVersion              = $OS.ServicePackMajorVersion
                    OSVersion              = $OS.Version
                    Model                  = $CS.Model

                }

            }

            Catch {

                Write-Verbose "Unable to establish CIM instance to $Computer"
                $Property = @{
                    Status            = 'Unsuccessful'
                    ComputerName      = $Computer
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