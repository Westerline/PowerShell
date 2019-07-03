﻿<#
To do:
#>
[cmdletbinding()]

Param(
    
    [String []] $InputFile,
    [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160', 'All')] 
    [String []] $Algorithm = 'All'

)


Foreach ($File in $InputFile) {

    $Property = [Ordered]@{
        File = $File
    }

    If ($Algorithm -eq 'All') { $Algorithm = 'SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160' }

    Foreach ($Alg in $Algorithm) {
        $Hash = Get-FileHash -Path $File -Algorithm $Alg 
        $Property.Add($Alg, $Hash.Hash)
    }

    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object

}