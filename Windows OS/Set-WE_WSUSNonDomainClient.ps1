Function Set-WE_WSUSNonDomainClient {

    <#
.SYNOPSIS
    ...

.DESCRIPTION
    ...

.PARAMETER ParameterName
    ...

.Inputs

.Outputs
    <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

.EXAMPLE
    <Example goes here. Repeat this attribute for more than one example>

.NOTES
  Version: 1.0
  Author(s): Wesley Esterline
  Creation Date: <Date>
  Purpose/Change: Initial script development
  Resources: https://community.spiceworks.com/how_to/85392-wsus-targeting-for-non-domain-computers
  To Do: Option to restore default settings via : rem REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate", post tool to Spiceworks.
#>


    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [String] $HostName,

        [ValidateNotNullOrEmpty()]
        [Int] $Port = 8530,

        [String] $WUGroup,

        [Switch] $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $WindowsUpdate = New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name WindowsUpdate -ItemType File -Force:$Force
            $AU = New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "AU" -ItemType File -Force:$Force
            $WUServer = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUServer" -Value "http://$HostName`:$Port/" -Force:$Force
            $WUStatusServer = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUStatusServer" -Value "http://$HostName`:$Port/" -Force:$Force
            $TargetGroup = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "TargetGroup" -Value "$WUGroup" -Force:$Force
            $TargetGroupEnabled = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "TargetGroupEnabled" -Value 1 -PropertyType Dword -Force:$Force
            $AutoDownload = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 3 -PropertyType Dword -Force:$Force
            $OptionalRestart = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -PropertyType Dword -Force:$Force
            $AutoUpdate = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 0 -PropertyType Dword -Force:$Force
            $UseWUServer = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value 1 -PropertyType Dword -Force:$Force
            Restart-Service -Name WUAUSERV -Force:$Force
            wuauclt.exe /reportnow /detectnow
            $Property = @{
                WindowsUpdate      = $WindowsUpdate.Name
                AU                 = $AU.Name
                WUServer           = $WUServer.Name
                WUStatusServer     = $WUStatusServer.Name
                TargetGroup        = $TargetGroup.Name
                TargetGroupEnabled = $TargetGroupEnabled.Name
                AutoDownload       = $AutoDownload.Name
                OptionalRestart    = $OptionalRestart.Name
                AutoUpdate         = $AutoUpdate.Name
                UseWUServer        = $UseWUServer.Name
            }

        }

        Catch {

            Write-Verbose "Unable to set a conneciton to the WSUS server $HostName on client $Env:COMPUTERNAME."
            $Property = @{
                WUServer           = 'Null'
                WUStatusServer     = 'Null'
                TargetGroup        = 'Null'
                TargetGroupEnabled = 'Null'
                AutoDownload       = 'Null'
                OptionalRestart    = 'Null'
                AutoUpdate         = 'Null'
                UseWUServer        = 'Null'
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