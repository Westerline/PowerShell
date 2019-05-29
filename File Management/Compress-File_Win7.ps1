#Lists IP Address for network adapters, can be passed as an object. Creates substring which contains store number.

$IPAddress = @(@(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*")[0]
$StoreNumber = $IPAddress.Substring(8,3)


$Date = (Get-Date).Day,-(Get-Date).Month,-(Get-Date).Year

If (!(Test-Path C:\temp)) {
mkdir C:\temp
}
Get-ChildItem -Recurse -Path C:\InfinityTools\Backups | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Compress-Archive -CompressionLevel Optimal -DestinationPath "C:\temp\($date).zip" -Force

function Get-FriendlySize {
    param($Bytes)
    $sizes='Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for($i=0; ($Bytes -ge 1kb) -and 
        ($i -lt $sizes.Count); $i++) {$Bytes/=1kb}
    $N=2; if($i -eq 0) {$N=0}
    "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}


Get-ChildItem -Path C:\temp| Select-Object -Property @{N='FriendlySize';E={Get-FriendlySize -Bytes $_.Length}} >> C:\temp\ArchiveSize.txt