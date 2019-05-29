$Content = Get-Content \\$Computer\c$\test.txt

$LineNumber = ($Content | Select-String -Pattern 'Test*' | Select-Object -ExpandProperty LineNumber) - 1

$Content[$LineNumber] = 'Test=0'