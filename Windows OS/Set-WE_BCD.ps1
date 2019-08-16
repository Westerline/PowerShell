Function Set-WE_BCD {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        MBR: Commands to use If the Image is not Sysprepped (not recommended), or BCD needs to be configured for MBR booting.
        ViewStore:To view the contents of the BCD store, run the following command at the command prompt
        VHD:The following commands can be used to alter the BCD store for a mounted Virtual Hard Drive
        MBR&UEFI:Use the below to setup a WIndows to Go Hard Drive with MBR and UEFI booting capability. Requires the disk to be initialized as MBR, a 350 MB Fat32 partition for system files, and another partition with NTFS formatting for the Windows operating system files.

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
        ResourceS:
            -
        To Do:
            -Add drive letter parameters
            -Paramterize bootloader configurations
            -Product standard output for each BCD edit type
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

        [Parameter(Mandatory = $True,
            ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Installer')]
        [Parameter(ParameterSetName = 'PSScript')]
        [Parameter(ParameterSetName = 'SQLQuery')]
        [Parameter(ParameterSetName = 'SQLScript')]
        [Parameter(ParameterSetName = 'Regedit')]
        [ValidateSet('MBR&UEFI', 'ViewStore', 'MBR', 'VHD')]
        [String]
        $Type

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'

            Switch ($Type) {

                'MBR&UEFI' { bcdboot.exe W:\Windows /s S: /f ALL }
                'ViewStore' { bcdedit.exe /enum all /store $Store }
                'MBR' {
                    bcdedit.exe /store S:\boot\bcd /set { bootmgr } device partition=S:
                    bcdedit.exe /store S:\boot\bcd /set { default } device partition=C:
                    bcdedit.exe /store S:\boot\bcd /set { default } osdevice partition=C:
                }
                'VHD' {
                    bcdedit.exe /store v:\boot\bcd /set { bootmgr } device partition=v:
                    bcdedit.exe /store v:\boot\bcd /set { bootmgr } integrityservices enable
                    bcdedit.exe /store v:\boot\bcd /set { <Identifier> } device partition=w:
                    bcdedit.exe /store v:\boot\bcd /set { <Identifier> } integrityservices enable
                    bcdedit.exe /store v:\boot\bcd /set { <identifier> } recoveryenabled Off
                    bcdedit.exe /store v:\boot\bcd /set { <identifier> } osdevice partition=w:
                    bcdedit.exe /store v:\boot\bcd /set { <identifier> } bootstatuspolicy IgnoreAllFailures
                }

            }

            $ErrorActionPreference = $StartErrorActionPreference

        }

        Catch {

            Write-Verbose "Unable to configure BCD settings for type $Type."

        }

        Finally { }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}