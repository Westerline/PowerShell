<#
Requires -runasadministrator
#>

Function Get-WE_PublicIP {

    [CmdletBinding()]

    Param ( )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $IPify = Invoke-RestMethod -Uri 'https://api.ipify.org' -ErrorAction Stop
            $OpenDNS = ((nslookup.exe myip.opendns.com. resolver1.opendns.com 2>$Null)[4]).substring(10)
            $Property = @{
                'IPify-PublicIP'   = $IPify
                'OpenDNS-PublicIP' = $OpenDNS
            }

        }

        Catch {

            Write-Verbose "Unable to get public IP address for $LocalHost."
            $Property = @{
                'IPify-PublicIP'   = 'Null'
                'OpenDNS-PublicIP' = 'Null'
            }

        }

        FInally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}