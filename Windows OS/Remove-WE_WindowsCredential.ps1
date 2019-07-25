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

Begin { }

Process {

    Foreach ($N in $Name) {

        Try {

            $CmdKey = & CmdKey /Delete:$N


            $Property = @{
                Status             = $CmdKey
                CredentialHostName = & CmdKey /List | findstr $N
            }

        }

        Catch {

            $Property = @{
                Status             = "$CmdKey Null"
                CredentialHostName = & CmdKey /List | findstr $N
            }

        }

        Finally {
    
            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }
    
    }

}

End { }