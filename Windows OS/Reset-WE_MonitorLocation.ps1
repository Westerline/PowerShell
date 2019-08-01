Function Reset-WE_MonitorLocation {

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
            -Registry exporting function
            -Backup $Path1 and $Path2 prior to deletion.
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

    Param ( )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $Configuration = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration'
            $Connectivity = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity'
            Remove-Item -Path $Configuration, $Connectivity -Recurse -ErrorAction Stop
            $Property = @{
                Status       = 'Successful'
                ComputerName = $Env:COMPUTERNAME
            }

        }

        Catch [System.Management.Automation.RuntimeException] {

            Write-Verbose "Path to $Configuration or $Connectivity doesn't exist. Please reboot $Env:COMPUTERNAME to re-create the required registry keys and run the cmdlet again."
            $Property = @{
                Status       = 'Unsuccessful'
                ComputerName = $Env:COMPUTERNAME
            }

        }

        Catch {

            Write-Verbose "Unable to reset monitor configuration on $Env:COMPUTERNAME. Please ensure you have administrator access to the registry and run the cmdlet again."
            $Property = @{
                Status       = 'Unsuccessful'
                ComputerName = $Env:COMPUTERNAME
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