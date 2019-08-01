Function Format-WE_WindowstoGo {

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
            -Parameters for Syspart size, letter, winpart letter, label.
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
        [Alias('DiskName', 'Name')]
        [String]
        $FriendlyName

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $WINTOGO_Drive = Get-Disk -FriendlyName $FriendlyName | Select-Object -ExpandProperty Number
            $Initialization = Initialize-Disk -Number $WINTOGO_Drive -PartitionStyle MBR
            $SystemPartition = New-Partition - -Size 350MB -DriveLetter 'S' -IsActive
            $SystemVolume = Format-Volume -DriveLetter 'S' -FileSystem FAT32 -NewFileSystemLabel "System"
            $WindowsParition = New-Partition -DiskNumber $WINTOGO_Drive -UseMaximumSize -DriveLetter 'W'
            $WindowsVolume = Format-Volume -DriveLetter 'W' -FileSystem NTFS -NewFileSystemLabel "Windows To Go"
            $BCD = bcdboot.exe W:\Windows /s S: /f ALL
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                Status           = 'Successful'
                Initialization   = $Initialization
                SystemPartition  = $SystemPartition
                SystemVolume     = $SystemVolume
                WindowsPartition = $WindowsParition
                WindowsVolume    = $WindowsVolume
                BCD              = $BCD
            }

        }

        Catch {

            Write-Verbose "Unable to format Windows-to-Go drive $FriendlyName."
            $Property = @{
                Status           = 'Unsuccessful'
                Initialization   = 'Null'
                SystemPartition  = 'Null'
                SystemVolume     = 'Null'
                WindowsPartition = 'Null'
                WindowsVolume    = 'Null'
                BCD              = 'Null'
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