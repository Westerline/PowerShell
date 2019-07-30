<#
Requirements: Windows 10
#>

[Cmdletbinding()]

Param( )

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Try {
       
        $CurrentVersion = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
        $Property = @{
            ProductName = $CurrentVersion.ProductName
            ReleaseID   = $CurrentVersion.ReleaseID
            EditionID   = $CurrentVersion.EditionID
        }

    }

    Catch {

        $Property = @{
            ProductName = 'Null'
            ReleaseID   = 'Null'
            EditionID   = 'Null'
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