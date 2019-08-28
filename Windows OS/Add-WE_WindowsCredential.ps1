Function Add-WE_WindowsCredential {

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
            -Expand function to allow CSV import as input (2) secure string parameter and then convert back to plaintext for CmdKey.
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [Cmdletbinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('ComputerName')]
        [String[]]
        $HostName,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserName,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Password,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('Domain', 'SmartCard', 'Generic')]
        [String[]]
        $Type

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'

            Switch ($Type) {

                Domain { $CmdKey = & cmdkey.exe /Add:$HostName /User:$UserName /Pass:$Password }
                SmartCard { $CmdKey = & cmdkey.exe /Add:$HostName /SmartCard }
                Generic { $CmdKey = & cmdkey.exe /Generic:$HostName /User:$UserName /Pass:$Password }

            }

            $ErrorActionPreference = $StartErrorActionPreference

            $Property = @{
                Status             = $CmdKey
                CredentialHostName = & cmdkey.exe /List | findstr.exe $HostName
            }

        }

        Catch {

            Write-Verbose "Unable to add windows credential for hostname $HostName."
            $Property = @{
                Status             = "Unsucessful"
                CredentialHostName = & cmdkey.exe /List | findstr.exe $HostName
                ExceptionMessage   = $_.Exception.Message
                ExceptionItemName  = $_.Exception.ItemName
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}