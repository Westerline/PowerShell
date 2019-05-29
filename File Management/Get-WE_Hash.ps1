Write-Output "Please enter the full path to the file you'd like to Hash check, surrounded by double quotes (`")"
$InputFile = Read-Host

$SHA1 = Get-FileHash $InputFile -Algorithm SHA1
$SHA256 = Get-FileHash $InputFile -Algorithm SHA256
$SHA384 = Get-FileHash $InputFile -Algorithm SHA384
$SHA512 = Get-FileHash $InputFile -Algorithm SHA512
$MACTripleDES = Get-FileHash $InputFile -Algorithm MACTripleDES
$MD5 = Get-FileHash $InputFile -Algorithm MD5
$RIPEMD160 = Get-FileHash $InputFile -Algorithm RIPEMD160

$Properties = [Ordered] @{File = $InputFile
                        SHA1 = $SHA1.Hash
                        SHA256 = $SH256.Hash
                        SHA384 = $SHA384.Hash
                        SHA512 = $SHA512.Hash
                        MACTripleDES = $MACTripleDES.Hash
                        MD5 = $MD5.Hash
                        RIPEMD160 = $RIPEMD160.Hash
                        }

New-Object -TypeName PSObject -Property $Properties | Out-Host