<#
To do: expand function to allow CSV import as input
#>

Param(
    [String] $Name
)

Begin { }

Process {

    Try {

        $CmdKey = & CmdKey /Delete:$Name


        $Property = @{
            Status             = $CmdKey
            CredentialHostName = & CmdKey /List | findstr $Name
        }

    }

    Catch {

        $Property = @{
            Status             = "$CmdKey Null"
            CredentialHostName = & CmdKey /List | findstr $Name
        }

    }

    Finally {
    
        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object

    }

}

End { }