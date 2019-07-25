<#
.Notes
    To do: Parameters for Syspart size, letter, winpart letter, label.
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

Begin { }

Process {
    
    Try {

        $WINTOGO_Drive = Get-Disk -FriendlyName $FriendlyName | Select-Object -ExpandProperty Number

        $Initialization = Initialize-Disk -Number $WINTOGO_Drive -PartitionStyle MBR

        $SystemPartition = New-Partition - -Size 350MB -DriveLetter 'S' -IsActive

        $SystemVolume = Format-Volume -DriveLetter 'S' -FileSystem FAT32 -NewFileSystemLabel "System"

        $WindowsParition = New-Partition -DiskNumber $WINTOGO_Drive -UseMaximumSize -DriveLetter 'W'

        $WindowsVolume = Format-Volume -DriveLetter 'W' -FileSystem NTFS -NewFileSystemLabel "Windows To Go"

        $BCD = bcdboot W:\Windows /s S: /f ALL

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

        Write-Verbose ""
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

End { }