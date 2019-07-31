<#
.To Do
    Add Remove-WE_Credentials function
#>

[Cmdletbinding()]

Param ( )

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Try {

        $ShadowCopies = & vssadmin.exe Delete Shadows /All
        $SoftwareDistribution = Remove-Item 'C:\Windows\SoftwareDistribution\Download\*.*' -Recurse
        $Prefetch = Remove-Item 'C:\Windows\Prefetch\*.*' -Recurse
        $DiskCleanup = cleanmgr.exe /sagerun:1
        $ClearEventLog = Get-EventLog -LogName * | ForEach-Object { Clear-EventLog $_.Log }
        $DNSCache = Clear-DnsClientCache
        $Property = @{
            ShadowCopies         = $ShadowCopies
            SoftwareDistribution = $SoftwareDistribution
            Prefetch             = $Prefetch
            DiskCleanup          = $DiskCleanup
            ClearEventLog        = $ClearEventLog
            DNSCache             = $DNSCache
        }

    }

    Catch {

        Write-Verbose "Unable to complete pre-sysprep operations on $Env:COMPUTERNAME."
        $Property = @{
            ShadowCopies         = $ShadowCopies
            SoftwareDistribution = $SoftwareDistribution
            Prefetch             = $Prefetch
            DiskCleanup          = $DiskCleanup
            ClearEventLog        = $ClearEventLog
            DNSCache             = $DNSCache
        }

    }

    Finally {

        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference

}