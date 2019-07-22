<#
.To Do
    Add Remove-WE_Credentials function
#>

Try {
       
    $ShadowCopies = & Vssadmin Delete Shadows /All
    $SoftwareDistribution = Remove-Item 'C:\Windows\SoftwareDistribution\Download\*.*' -Recurse
    $Prefetch = Remove-Item 'C:\Windows\Prefetch\*.*' -Recurse
    $DiskCleanup = C:\windows\system32\cleanmgr.exe /sagerun:1
    $ClearEventLog = Get-EventLog -LogName * | ForEach-Object { Clear-EventLog $_.Log }
    $DNSCache = Clear-DnsClientCache
    $Property = @{ }
}

Catch {


}

Finally {

}