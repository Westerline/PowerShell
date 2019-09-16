Function Start-WE_Pre-Sysprep {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

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

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -
        To Do:
            -Add Remove-WE_Credentials function
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

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
            $ShadowCopies = & vssadmin.exe Delete Shadows /All
            $SoftwareDistribution = Remove-Item 'C:\Windows\SoftwareDistribution\Download\*.*' -Recurse -Force:$Force
            $Prefetch = Remove-Item 'C:\Windows\Prefetch\*.*' -Recurse -Force:$Force
            & cleanmgr.exe /sagerun:1
            Get-Process -Name 'cleanmgr' | Wait-Process
            $ClearEventLog = Get-EventLog -LogName * | ForEach-Object { Clear-EventLog $_.Log }
            $DNSCache = ipconfig.exe /flushdns
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                ShadowCopies         = $ShadowCopies
                SoftwareDistribution = $SoftwareDistribution
                Prefetch             = $Prefetch
                DiskCleanup          = 'Successful'
                ClearEventLog        = $ClearEventLog
                #DNSCache             = $DNSCache
            }

        }

        Catch {

            Write-Verbose "Unable to complete pre-sysprep operations on $Env:COMPUTERNAME."
            $Property = @{
                Status            = 'Unsucessful'
                ComputerName      = $Env:COMPUTERNAME
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