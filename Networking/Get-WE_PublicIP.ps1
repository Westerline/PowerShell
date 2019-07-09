<#
Requires -runasadministrator
#>
Try {
    $IPify = Invoke-RestMethod -Uri 'https://api.ipify.org'
    $OpenDNS = ((nslookup myip.opendns.com. resolver1.opendns.com 2>$Null)[4]).substring(10)
    $Property = @{
        'IPify-PublicIP'   = $IPify
        'OpenDNS-PublicIP' = $OpenDNS 
    }
}

Catch {

}

FInally {
    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}