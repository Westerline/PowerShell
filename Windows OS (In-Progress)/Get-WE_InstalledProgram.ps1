<#
Source: modified from https://devblogs.microsoft.com/scripting/use-powershell-to-quickly-find-installed-software/
#>
Begin { }

Process {
    Try {
        $Program = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -ne $Null } | Select-Object -Property DisplayName, Developer, Version, InstallDate
    }

    Catch { }

    Finally {
        Write-Output $Program
    }
}

End { }