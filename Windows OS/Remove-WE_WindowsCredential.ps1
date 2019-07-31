<#
To do: expand function to allow CSV import as input
#>

[Cmdletbinding()]

Param(

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Alias('UserName')]
    [String[]]
    $Name

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Foreach ($N in $Name) {

        Try {

            $CmdKey = & cmdkey.exe /Delete:$N


            $Property = @{
                Status             = 'Successful'
                CMDKey             = $CmdKey
                CredentialHostName = & cmdkey.exe /List | findstr.exe $N
            }

        }

        Catch {

            Write-Verbose "Unable to remove windows credentials for host $N"
            $Property = @{
                Status             = 'Unsuccessful'
                CMDKey             = 'Null'
                CredentialHostName = $N
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference

}