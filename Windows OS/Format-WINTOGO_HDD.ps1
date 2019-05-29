$FriendlyName = "asmedia ASMT1153e"

$WINTOGO_Drive=Get-Disk | Where-Object {($_.FriendlyName -eq $FriendlyName) -and ($_.size -ge 500gb)} | Select-Object -ExpandProperty Number

If (Get-PhysicalDisk | Where-Object {$_.FriendlyName -eq $FriendlyName}) {

Write-Output Windows To Go hard drive detected.

Write-Output Creating partition scheme on disk

Initialize-Disk -Number $WINTOGO_Drive -PartitionStyle MBR

New-Partition -DiskNumber $WINTOGO_Drive -Size 350MB -DriveLetter 'S' -IsActive

Format-Volume -DriveLetter 'S' -FileSystem FAT32 -NewFileSystemLabel "System"

New-Partition -DiskNumber $WINTOGO_Drive -UseMaximumSize -DriveLetter 'W'

Format-Volume -DriveLetter 'W' -FileSystem NTFS -NewFileSystemLabel "Windows To Go"


#Macrium Reflect Options
    #Restore Tab > Browse for an image file > Select image file
    #Restore only the Windows partition to just the W: partition on the new hard drive
    #Select "Restore Partition Properties" > Click [Maximum size] > Allocate Drive Letter: W
    #Next > Advanced Options > MBR Options > Click [Do not replace]

Wait-Process -Name Reflect
Write-Output Setting up BCD Files
bcdboot W:\Windows /s S: /f ALL

}

Else {

Write-Output No Windows To Go hard drive detected. Please reconnect and run the script again.

}