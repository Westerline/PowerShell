<#
Source: modified from https://devblogs.microsoft.com/scripting/use-powershell-to-quickly-find-installed-software/
.Notes
    To Do: (1) Custom Format File for alphabetical sorting of output (2) Select default properties in output PS Module Manifest
#>

[Cmdletbinding()]

Param ( )

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Try {
        $OSArchitecture = Get-WmiObject -Class WIn32_OperatingSystem | Select-Object -ExpandProperty OSArchitecture

        If ($OSArchitecture -eq '64-bit') {
            $x64Program = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -ne $Null }
            $x86Program = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -ne $Null }
            $AllPrograms = Compare-Object -Property DisplayName -ReferenceObject $x64Program -DifferenceObject $x86Program -IncludeEqual -PassThru
        }

        Elseif ($OSArchitecture -eq '32-bit') {
            $AllPrograms = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -ne $Null }
        }
    }

    Catch { }

    Finally {
        
        Write-Output $AllPrograms

    }
    
}

End {

    $ErrorActionPreference = $StartErrorActionPreference 

}