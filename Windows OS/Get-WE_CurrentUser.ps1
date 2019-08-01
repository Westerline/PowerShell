﻿Function Get-WE_CurrentUser {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Requirements, WinRM service should be configured to accept requests.

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

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('HostName')]
        [String[]]
        $ComputerName

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        ForEach ($Computer in $ComputerName) {

            Try {

                $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
                $ComputerSystem = Get-CimInstance -CimSession $Session -ClassName Win32_ComputerSystem
                $Property = @{
                    Status   = 'Successful'
                    Computer = $Computer
                    UserName = $ComputerSystem.UserName
                }

            }

            Catch {

                Write-Verbose "Unable to get the currently logged in user for $Computer. Please ensure the computer is available on the network."
                $Property = @{
                    Status   = 'Unsuccessful'
                    Computer = $Computer
                    UserName = 'Null'
                }

            }

            Finally {

                $Object = New-Object -TypeName psobject -Property $Property
                Write-Output $Object

            }
        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}