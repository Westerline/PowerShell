Function Set-WE_WUSlipstream {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        To Slipstream Updates into a WIM file or Windows ISO, use these commands as an outline.
        Then from the appropriate Windows AIK Toolkit Command Prompt. Convert the WIM to ISo.
        -m = max file size ignored
        -u2 = UDF file system only, no legacy ISO 9660 file system for DOS
        -b = Specifies the El Torito boot sector file that will be written in the boot sector or sectors of the disk. Do not use spaces. For example:
            On UEFI: -bC:\winpe_x86\Efisys.bin
            On BIOS: -bC:\winpe_x86\Etfsboot.com

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

        C:\PS>Get-WE_FileVersion -Path (Get-ChildItem -File -Path $Path | Where-Object { $_.VersionInfo.FileVersion -ne $Null })

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
        [validatenotnullorempty()]
        [Alias('FileName')]
        [String]
        $Path,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [validatenotnullorempty()]
        [String]
        $ImagePath,

        [Parameter(Mandatory = $True)]
        [validatenotnullorempty()]
        [String]
        $Name,


        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [validatenotnullorempty()]
        [String]
        $PackagePath,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [validatenotnullorempty()]
        [String]
        $BootSectorFile,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [validatenotnullorempty()]
        [String]
        $ISOPath


    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $MountedImage = Mount-WindowsImage -Path $Path -ImagePath $ImagePath -Name $Name
            $AddPackage = Add-WindowsPackage -Path $Path -PackagePath $PackagePath
            Dismount-WindowsImage -Path $Path -Save
            $oscdimg = & "$PSScriptRoot\oscdimg\oscdimg.exe" -m -u2 -b$BootSectorFile $Path $ISOPath
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                Status       = 'Successful'
                MountedImage = $MountedImage
                AddPackage   = $AddPackage
                oscdimg      = $oscdimg
            }

        }

        Catch {

            Write-Verbose "Unable to add Windows package to the windows image $ImagePath."
            $Property = @{
                Status       = 'Unsuccessful'
                MountedImage = 'Null'
                AddPackage   = 'Null'
                oscdimg      = 'Null'
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