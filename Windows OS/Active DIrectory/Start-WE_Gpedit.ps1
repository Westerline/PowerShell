<#
#>

Function Start-WE_Gpedit {

    [Cmdletbinding()]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('HostName')]
        [String[]] $ComputerName

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Computer in $ComputerName) {

            Try {

                & gpedit.msc /gpcomputer: $Computer

            }

            Catch {

                Write-Verbose "Unable to open gpedit on $Computer."

            }

            Finally { }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}