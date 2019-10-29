Function Set-WE_WSUSNonDomainClient {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

    .PARAMETER
        -HostName [<String[]>]
            Host name or IP address of the remote WSUS server, used by the client for fetching updates.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

        <CommonParameters>
            This cmdlet supports the common parameters: Verbose, Debug,
            ErrorAction, ErrorVariable, WarningAction, WarningVariable,
            OutBuffer, PipelineVariable, and OutVariable. For more information, see
            about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

        -HostName [<String[]>]
            Host name or IP address of the remote WSUS server, used by the client for fetching updates.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -Modified from https://community.spiceworks.com/how_to/85392-wsus-targeting-for-non-domain-computers
        To Do:
            -Backup original registry settings
            -Option to restore default settings via : rem REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
            -Set $WUGroup as an optional parameter, set $TargetGroup and $TargetGroupEnabled as "if exists $WUGroup"
            -Post tool to Spiceworks.
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('ComputerName')]
        [String[]]
        $HostName,

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [Alias('UpdateGroup', 'Group')]
        [String]
        $WUGroup = 'Unassigned Computers',

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $Port = 8530,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
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
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                WindowsUpdate      = $WindowsUpdate.Name
                AU                 = $AU.Name
                WUServer           = $WUServer.WUServer
                WUStatusServer     = $WUStatusServer.WUStatusServer
                TargetGroup        = $TargetGroup.TargetGroup
                TargetGroupEnabled = $TargetGroupEnabled.TargetGroupEnabled
                AutoDownload       = $AutoDownload.AUOptions
                OptionalRestart    = $OptionalRestart.NoAutoRebootWithLoggedOnUsers
                AutoUpdate         = $AutoUpdate.NoAutoUpdate
                UseWUServer        = $UseWUServer.UseWUServer
            }

        }

        Catch {

            Write-Verbose "Unable to set a conneciton to the WSUS server $HostName on client $Env:COMPUTERNAME."
            $Property = @{
                Status            = 'Unsucessful'
                ShortcutTarget    = $HostName
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
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