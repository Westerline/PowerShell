<#
Requirements: Windows 10
#>

Function Get-WE_WindowsVersion {

    [Cmdletbinding()]

    Param( )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $CurrentVersion = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop
            $Property = @{
                ProductName = $CurrentVersion.ProductName
                ReleaseID   = $CurrentVersion.ReleaseID
                EditionID   = $CurrentVersion.EditionID
            }

        }

        Catch {

            Write-Verbose "Unable to get windows version on $Env:COMPUTERNAME."
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

}