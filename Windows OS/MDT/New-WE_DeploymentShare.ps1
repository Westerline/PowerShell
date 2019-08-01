Function New-WE_DeploymentShare {

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
            -
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

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Description,

        [ValidateNotNullOrEmpty()]
        [String]
        $FullAccess = 'Adinistrators'


    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
            $Directory = New-Item -Path $Path -ItemType directory
            $SMBShare = New-SmbShare -Name $Name -Path $Path -FullAccess $FullAccess
            $PSDrive = New-PSDrive -Name $Name -PSProvider "MDTProvider" -Root $Path -Description $Description -NetworkPath "\\$Env:ComputerName\$Name"
            $MDTDrive = Add-MDTPersistentDrive -Name $Name -InputObjetc $PSDrive
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                Status     = 'Successful'
                Directory  = $Directory.Directory
                ShareState = $SMBShare.ShareState
                PSDrive    = $PSDrive.Name
                MDTDrive   = $MDTDrive.$Name
            }

        }

        Catch {

            Write-Verbose "Unable to create the MDT Deployment Share $Name."
            $Property = @{
                Status     = 'Unsuccessful'
                Directory  = 'Null'
                ShareState = 'Null'
                PSDrive    = 'Null'
                MDTDrive   = 'Null'
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