$Computers = Get-Content "\\NNDADFP1\Support Centre\Operations\Master Files\Tokens\BOS\BOS.txt"

Foreach ($Computer in $Computers) {

Test-NetConnection $Computer -CommonTCPPort HTTP | Out-File -FilePath 'C:\temp\PSRemote_BOS.txt' -Append

}