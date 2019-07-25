<#
.Description
    https://blogs.u2u.be/u2u/post/creating-a-self-signed-code-signing-certificate-from-powershell
    Generates self-signed powershell code signing certificate. Should only be used in test environments.
    Certificate must be moved to the local machine's trusted root and trusted publisher stores for the code to be executed.
#>

[Cmdletbinding(SupportsShouldProcess)]

Param(

    [ValidateNotNullOrEmpty()]
    [Int] 
    $Duration = 3,
    
    [ValidateNotNullOrEmpty()]
    [String] 
    $Subject = "PowerShell Code Signing Certificate",
    
    [ValidateNotNullOrEmpty()]
    [String]
    $CertStoreLocation = "Cert:\LocalMachine\My"

)


Try {
    $NotAfter = $([datetime]::now.AddYears($Duration))
    $Certificate = New-SelfSignedCertificate -Subject $Subject -Type CodeSigningCert -NotAfter $NotAfter -CertStoreLocation $CertStoreLocation
    $TrustedRoot = Copy-Item -Path $Certificate.PSPath -Destination "Cert:\LocalMachine\Root"
    $TrustedPublisher = Move-Item -Path $Certificate.PSPath -Destination "Cert:\LocalMachine\TrustedPublisher"
    $Property = @{
        Thumbprint       = $Certificate.Thumbprint
        TrustedRoot      = $TrustedRoot
        TrustedPublisher = $TrustedPublisher
    }
}

Catch { 
    $Property = @{
        Thumbprint       = 'Null'
        TrustedRoot      = 'Null'
        TrustedPublisher = 'Null'
    }
}

Finally {
    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}