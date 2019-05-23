#Creates a new object in the excel application, opens the workbook, and then opens the worksheet
$File = "C:\test.txt"
$SheetName = 'test1'
$ObjExcel = New-Object -ComObject Excel.Application
$Workbook = $ObjExcel.Workbooks.Open($File)
$Sheet = $Workbook.Worksheets.Item($SheetName)
$ObjExcel.Visible = $false

#Checks the number of rows that have values
$Rowmax = ($Sheet.UsedRange.Rows).count

#Declares starting position for each column
$Row1, $ColBranch = 1, 1
$RowName, $ColName = 1, 2
$RowStaticIP, $ColStaticIP = 1, 3
$RowUserName, $ColUsername = 1, 4
$RowPassword, $ColPassword = 1, 5

#The next step is to loop through each row and store each variable that you can use for anything you want

for ($i = 1; $i -le $rowMax - 1; $i++) {
    $name = $sheet.Cells.Item($rowName + $i, $colName).text
    $age = $sheet.Cells.Item($rowAge + $i, $colAge).text
    $city = $sheet.Cells.Item($rowCity + $i, $colCity).text

}

#Prompt the user to enter the password for the encrypted drive, as secure string.
$Stored_Credential = Read-Host '<Enter Prompt Here>' -AsSecureString

#Convert to Plain Text
[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Stored_Credential)