Function Set-WE_OfficeProductKey {

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
            -Fix repeated Product ID: ProductID =, develop better method for selecting the substring
        Misc:
            -Requires -runasadministrator

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = 'Product key must match the format XXXXX-XXXXX-XXXXX-XXXXX-XXXXX',
            Position = 0)]
        [ValidatePattern('\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w')]
        [Alias('LicenseKey')]
        [String[]]
        $ProductKey,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS' -Force:$Force -ErrorAction SilentlyContinue
            $ErrorActionPreference = 'Stop'
            $ChangeKey = cscript.exe $OSPP.FullName /inpkey:$ProductKey
            $ActivationStatus = cscript.exe $OSPP.FullName /act
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                InputKey = $ProductKey
                ProductKeyInstallStatus = $ChangeKey | Select-String '<'
                ActivationStatus = $ActivationStatus | Select-String '<'
                LicenseName = $ActivationStatus | Select-String 'LICENSE NAME'
                LicenseDescription = $ActivationStatus | Select-String 'LICENSE DESCRIPTION'
                Last5Characters = $ActivationStatus | Select-String 'Last 5 characters of installed product key'
            }

        }

        Catch {

            Write-Verbose "Unable to activate product key $ProductKey on $Env:COMPUTERNAME. Verify a path is available to OSPP.VBS."
            $Property = @{
                Status            = 'Unsuccessful'
                Computer          = $Env:COMPUTERNAME
                InputKey = $ProductKey
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