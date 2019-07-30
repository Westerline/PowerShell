<#
To do:
#>
[cmdletbinding()]

Param(
    
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [validatenotnullorempty()] 
    [String []] 
    $InputFile,

    [Parameter(Mandatory = $False)]
    [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160', 'All')] 
    [String] 
    $Algorithm = 'All'

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

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

}

End {

    $ErrorActionPreference = $StartErrorActionPreference 
    
}