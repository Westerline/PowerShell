[cmdletbinding()]
Param(
    [String []] $InputFile,

    [ValidateSet("SHA1", "SHA256", "SHA384", "SHA512", "MACTripleDES", "MD5", "RIPEMD160", "ALL")] 
    [String []] $Algorithm = "All"
)

Foreach ($File in $InputFile) {

    Switch ($Algorithm) {

        SHA1 { 
            $SHA1 = Get-FileHash -Path $File -Algorithm SHA1 
            $Property = @{
                File = $File
                SHA1 = $SHA1.Hash
            }
        }
        
        SHA256 { 
            $SHA256 = Get-FileHash $File -Algorithm SHA256 
            $Property = @{
                File   = $File
                SHA256 = $SHA256.Hash
            }
        }

        SHA384 { 
            $SHA384 = Get-FileHash $File -Algorithm SHA384 
            $Property = @{
                File   = $File
                SHA384 = $SHA384.Hash
            }
        }

        SHA512 { 
            $SHA512 = Get-FileHash $File -Algorithm SHA512 
            $Property = @{
                File   = $File
                SHA512 = $SHA512.Hash
            }
        }

        MACTripleDES { 
            $MACTripleDES = Get-FileHash $File -Algorithm MACTripleDES 
            $Property = @{
                File         = $File
                MACTripleDES = $MACTripleDES.Hash
            }
        }

        MD5 { 
            $MD5 = Get-FileHash $File -Algorithm MD5 
            $Property = @{
                File = $File
                MD5  = $MD5.Hash
            }
        }

        RIPEMD160 { 
            $RIPEMD160 = Get-FileHash $File -Algorithm RIPEMD160 
            $Property = @{
                File      = $File
                RIPEMD160 = $RIPEMD160.Hash
            }
        }
        
        All {
            $SHA1 = Get-FileHash -Path $File -Algorithm SHA1
            $SHA256 = Get-FileHash $File -Algorithm SHA256 
            $SHA384 = Get-FileHash $File -Algorithm SHA384 
            $SHA512 = Get-FileHash $File -Algorithm SHA512
            $MACTripleDES = Get-FileHash $File -Algorithm MACTripleDES
            $MD5 = Get-FileHash $File -Algorithm MD5
            $RIPEMD160 = Get-FileHash $File -Algorithm RIPEMD160
            $Property = @{
                File         = $File
                SHA1         = $SHA1.Hash
                SHA256       = $SHA256.Hash
                SHA384       = $SHA384.Hash
                SHA512       = $SHA512.Hash
                MACTripleDES = $MACTripleDES.Hash
                MD5          = $MD5.Hash
                RIPEMD160    = $RIPEMD160.Hash
            }
        }
    
    }

        $Object = New-Object -TypeName psobject -Property $Property
        Write-Output $Object

    }