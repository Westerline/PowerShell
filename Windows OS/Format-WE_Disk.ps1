Function Format-WE_Disk {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Standard sequence to prepare a disk. Creates a windows and system partition which can be applied from an image, otherwise, these partitions are typically handled by the operating system installer.

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

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('DiskName', 'Name')]
        [String]
        $FriendlyName,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Help. Message. Here.",
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PartitionNumber

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $DiskId = Get-Disk -FriendlyName $FriendlyName | Select-Object -ExpandProperty Number
            $ClearDisk = Clear-Disk -RemoveData -UniqueId $DiskId
            $SystemPartition = New-Partition -DiskId $DiskId -Size 100 -DriveLetter 'S'
            $SystemVolume = Format-Volume -FileSystem NTFS -FileSystemLabel "System"
            $ActivePartition = Set-Partition -DriveLetter 'S' -IsActive $True
            $WindowsPartition = New-Partition -DiskId $DiskId -UseMaximumSize -DriveLetter 'C'
            $WindowsVolume = Format-Volume -FileSystem NTFS -FileSystemLabel "Windows"
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                Status           = 'Successful'
                ClearDisk        = $ClearDisk
                SystemPartition  = $SystemPartition
                SystemVolume     = $SystemVolume
                ActivePartition  = $ActivePartition
                WindowsPartition = $WindowsPartition
                WindowsVolume    = $WindowsVolume
            }

        }

        Catch {

            Write-Verbose "Error occurred formatting disk with Id: $DiskId."
            $Property = @{
                Status            = 'Unsuccessful'
                DiskID            = $FriendlyName
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