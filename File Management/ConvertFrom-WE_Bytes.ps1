<# Allows you to output an object's size in easy to read format for MB, KB, GB, etc.
E.g.
Get-ChildItem -Path C:\temp\temp.zip | Select-Object -Property Name, LastWriteTime, @{N='FriendlySize';E={ConvertFrom-WE_Bytes -Bytes $_.Length}}
#>

function ConvertFrom-WE_Bytes {
    param($Bytes)
    $sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for ($i = 0; ($Bytes -ge 1kb) -and 
        ($i -lt $sizes.Count); $i++) { $Bytes /= 1kb }
    $N = 2; if ($i -eq 0) { $N = 0 }
    "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}