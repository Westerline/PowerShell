<#
To do: expand function to allow CSV import as input
#>

Param(
    [String] $HostName,
    [String] $UserName,
    [String] $Password,
    [String] $Type
)

Begin { }

Process {

    Try {

        Switch ($Type) {

            Domain { $CmdKey = & CmdKey /Add:$HostName /User:$UserName /Pass:$Password }
            SmartCard { $CmdKey = & CmdKey /Add:$HostName /SmartCard }
            Generic { $CmdKey = & CmdKey /Generic:$HostName /User:$UserName /Pass:$Password }

        }

        $Property = @{
            Status             = $CmdKey
            CredentialHostName = & CmdKey /List | findstr $HostName
        }

    }

    Catch {

        $Property = @{
            Status             = "$CmdKey Null"
            CredentialHostName = & CmdKey /List | findstr $HostName
        }

    }

    Finally {
    
        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object
    }

}

End { }