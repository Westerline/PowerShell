<#
Requires GroupPolicy Module
To do: (1) Update property array (2) Tidy up Members parameter to accept input for various OU and DC locations.
#>
Param (
    [String] $ComputerName
)

Try {
    Foreach ($Computer in $ComputerName) {

        $GroupMemberComputer = Add-ADGroupMember -Identity $Identity -Members "CN=$Computer,OU=Computers,OU=Computers,OU=MyBusiness,DC=domain,DC=local"
        $Property = @{ 
            Status              = 'Successful'
            GroupMemberComputer = $GroupMemberComputer
        }
    }
}

Catch { 
    $Property = @{
        Status              = 'Unsuccessful'
        GroupMemberComputer = $GroupMemberComputer
    }
}

Finally {
    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}