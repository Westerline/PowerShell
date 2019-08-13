#Standard sequence to prepare a disk. Creates a windows and system partition which can be applied from an image, otherwise, these partitions are typically handled by the operating system installer.

#List Disk
Get-Disk

#Clean
Clear-Disk -RemoveData

#Create Partition Primary Size=100
New-Partition -DiskId $Disk -Size 100 -DriveLetter 'S'
New-Partition -DiskId $Disk -UseMaximumSize -DriveLetter 'C'
Set-Partition -DriveLetter 'S' -IsActive $True

#List Volume
Get-Partition -DiskId $DiskId -PartitionNumber $PartitionNumber

#Format.com FS=NTFS Quick Label="System"
Format-Volume -FileSystem NTFS