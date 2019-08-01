<#
Requires -runasadministrator
#>

Function Set-WE_OfficeProductKey {

    [CmdletBinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = 'Product key must match the format XXXXX-XXXXX-XXXXX-XXXXX-XXXXX')]
        [ValidatePattern('\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w')]
        [ValidateNotNullOrEmpty()]
        [Alias('LicenseKey')]
        [String[]]
        $ProductKey

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS' -ErrorAction SilentlyContinue
            $ErrorActionPreference = Stop
            $ChangeKey = cscript.exe $OSPP.FullName /inpkey:$ProductKey
            $Activate = cscript.exe $OSPP.FullName /act
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                OSPP      = $OSPP
                ChangeKey = $ChangeKey
                Activate  = $Activate
            }

        }

        Catch {

            Write-Verbose "Unable to activate product key $ProductKey on $Env:COMPUTERNAME. Verify a path is available to OSPP.VBS."
            $Property = @{
                OSPP      = 'Null'
                ChangeKey = 'Null'
                Activate  = 'Null'
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Verbose $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}