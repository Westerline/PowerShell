#Backup All AD users and properties to CSV
#Get-ADUser -Filter * -Properties * | Export-Csv C:\Temp\ADUsers_BAK.csv -Force

Foreach($user in (import-csv "c:\temp\test.csv")){
Get-ADUser -Filter "(DisplayName -eq '$($user.DisplayName)')" | Set-ADUser -MobilePhone $User.MobilePhone -Verbose
}

Foreach($user in (import-csv "c:\temp\test.csv")){
Get-ADUser -Filter "(DisplayName -eq '$($user.DisplayName)')" | Set-ADUser -HomePhone $User.HomePhone -Verbose
}

Foreach($user in (import-csv "c:\temp\test.csv")){
Get-ADUser -Filter "(DisplayName -eq '$($user.DisplayName)')" | Set-ADUser -OfficePhone $User.OfficePhone -Verbose
}


#Get-ADUser -Filter * -Properties TelephoneNumber,MobilePhone,HomePhone,OfficePhone | Select-Object -Property Name,TelephoneNumber,MobilePhone,HomePhone,OfficePhone