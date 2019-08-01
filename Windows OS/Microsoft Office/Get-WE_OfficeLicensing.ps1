<#
#>

Function Get-WE_OfficeLicensing {

    [CmdletBinding(SupportsShouldProcess)]

    Param( )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS' -ErrorAction SilentlyContinue
            $ErrorActionPreference = Stop
            $ActivactionStatus = cscript.exe $OSPP.FullName /dstatus
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                OSPP              = $OSPP
                ActivactionStatus = $ActivactionStatus
            }

        }

        Catch {

            Write-Verbose "Unable to retrieve Microsoft Office activation status on $Env:COMPUTERNAME. Verify a path is available to OSPP.VBS."
            $Property = @{
                OSPP              = 'Null'
                ActivactionStatus = 'Null'
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