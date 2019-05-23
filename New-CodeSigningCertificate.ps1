$Today = Get-Date

$File = C:\temp\test.ps1

$Cert_Duration = $([datetime]::now.AddYears(5))

$Cert = New-SelfSignedCertificate -Subject "PowerShell Code Signing Certificate" -Type CodeSigningCert -NotAfter $Cert_Duration -CertStoreLocation cert:\LocalMachine\My

Move-Item -Path $cert.PSPath -Destination "Cert:\LocalMachine\Root"

Set-AuthenticodeSignature -FilePath $File -Certificate $cert

Export-Certificate -Cert $Cert -FilePath C:\scripts -Type CERT