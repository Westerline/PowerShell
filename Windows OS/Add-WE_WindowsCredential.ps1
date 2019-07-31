<#
To do: expand function to allow CSV import as input (2) secure string parameter and then convert back to plaintext for CmdKey.
#>

Function Add-WE_WindowsCredential {

    [Cmdletbinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('ComputerName')]
        [String[]]
        $HostName,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserName,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Password,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('Domain', 'SmartCard', 'Generic')]
        [String[]]
        $Type

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            Switch ($Type) {

                Domain { $CmdKey = & cmdkey.exe /Add:$HostName /User:$UserName /Pass:$Password }
                SmartCard { $CmdKey = & cmdkey.exe /Add:$HostName /SmartCard }
                Generic { $CmdKey = & cmdkey.exe /Generic:$HostName /User:$UserName /Pass:$Password }

            }

            $Property = @{
                Status             = $CmdKey
                CredentialHostName = & cmdkey.exe /List | findstr.exe $HostName
            }

        }

        Catch {

            Write-Verbose "Unable to add windows credential for hostname $HostName."
            $Property = @{
                Status             = "$CmdKey Null"
                CredentialHostName = & cmdkey.exe /List | findstr.exe $HostName
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