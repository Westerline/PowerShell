$Username = ______

 

$FullName = ______

 

$Description = _________

 

$Password = Read-Host -AsSecureString

 

New-LocalUser -Name $Username -Password $Password -FullName $FullName -Description $Description -AccountNeverExpires $True -PasswordNeverExpires $True

 

Add-LocalGroupMember -Group Administrators -Name $Username
