$Value = "EmpID,Name,Dept
12345,John,Service
56789,Sarah,Sales
98765,Chris,Director"

$CSV = Set-Content -Path C:\temp\Test.CSV -Value $Value

$Object = Import-CSV -Path C:\temp\Test.CSV

$Object | Select-Object -Property @{Name = 'ID'; Expression = { $_.EmpID } }, Name, Dept