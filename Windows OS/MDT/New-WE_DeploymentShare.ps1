<#
#>

Function New-WE_DeploymentShare {

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

            Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
            $Directory = New-Item -Path $Path -ItemType directory
            $SMBShare = New-SmbShare -Name $Name -Path $Path -FullAccess $FullAccess
            $PSDrive = New-PSDrive -Name $Name -PSProvider "MDTProvider" -Root $Path -Description $Description -NetworkPath "\\$Env:ComputerName\$Name"
            $MDTDrive = Add-MDTPersistentDrive -Name $Name -InputObjetc $PSDrive
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