Function Get-WE_PublicIP {

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
            -Requires -runasadministrator

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding()]

    Param ( )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $IPify = Invoke-RestMethod -Uri 'https://api.ipify.org' -ErrorAction Stop
            $OpenDNS = ((nslookup.exe myip.opendns.com. resolver1.opendns.com 2>$Null)[4]).substring(10)
            $Property = @{
                'IPify-PublicIP'   = $IPify
                'OpenDNS-PublicIP' = $OpenDNS
            }

        }

        Catch {

            Write-Verbose "Unable to get public IP address for $LocalHost."
            $Property = @{
                'IPify-PublicIP'   = 'Null'
                'OpenDNS-PublicIP' = 'Null'
            }

        }

        FInally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}