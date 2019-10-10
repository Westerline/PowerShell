Function Install-WE_.Net3.5 {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        These functions can be used to install .NET 3.5 in Windows 10
        The first command attempts this using Windows Update, the second command installs .NET 3.5 from specified source.

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

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $False)]
        [Switch]
        $Offline

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'

            If ($Offline.IsPresent) {

                $DiskImage = Mount-DiskImage -ImagePath "$ImagePath"
                $VirtualDVDROM = Get-CimInstance -ClassName Win32_CDROMDrive -Filter "Caption = 'Microsoft Virtual DVD-ROM'"
                $Drive = $VirtualDVDROM.Drive
                $DotNet = Enable-WindowsOptionalFeature -FeatureName 'NetFx3' -All -LimitAccess -Source "$Drive\sources\sxs" -NoRestart
                $Property = @{
                    Status      = 'Successful'
                    'DotNet3.5' = $DotNet
                    DiskImage   = $DiskImage
                }

            }

            Else {

                $DotNet = Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -All
                $Property = @{
                    Status      = 'Successful'
                    'DotNet3.5' = $DotNet
                }


            }

            $ErrorActionPreference = $StartErrorActionPreference

        }

        Catch {

            Write-Verbose "Unable to install .Net 3.5 on $Env:COMPUTERNAME.
            Please try the offline option or ensure the offline media contains the necessary source files for .Net 3.5."
            $Property = @{
                Status            = 'Unsuccessful'
                ComputerName      = $Env:COMPUTERNAME
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
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