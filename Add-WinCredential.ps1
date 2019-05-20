#Example CSV column names are Number, Username, and Password
$ConnectionDetails = Import-Csv -Path C:\Temp\Test.txt


Foreach ($ConnectionDetail in $ConnectionDetails) {

$IP = $ConnectionDetail.Number
$Username = $ConnectionDetail.Username
$Password = $ConnectionDetail.Password
$LocalGroup = 

Try {

Write-Host "Adding $ConnectionDetail.Number"

& cmdkey /add:$IP /user:($UserName) /pass:$Password

& net localgroup $LocalGroup $Username /Add

Write-Host ""

}

Catch {

Write-Host "$ConnectionDetail.Number connection failed."

}

}