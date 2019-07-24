<#
.SYNOPSIS


.DESCRIPTION
    The following details how to create an isolated NAT'd network between your LAN, VM Server, and VM Clients
    The newly created VM switch is assigned an IP in a different network than your LAN, i.e. 192.168.0.1, we then create a NAT between the physical NIC and this virtual NIC.
    

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
 
.NOTES
    Author: Wesley Esterline
    Resources: https://www.petri.com/create-nat-rules-hyper-v-nat-virtual-switch
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
#>

Param (
    [String] $InterfaceAlias,
    [String] $Name,
    [String] $IPAddress,
    [String] $NetworkAddress,
    [String] $PrefixLength,
    [Switch] $NewSwitch
)

Begin { }

Process {

    Try {

        $NATAdapterIP = New-NetIPAddress -IPAddress $IPAddress -PrefixLength $PrefixLength -InterfaceAlias $InterfaceAlias
        $NAT = New-NetNAT -Name $Name -InternalIPInterfaceAddressPrefix ($NetworkAddress + '/' + $PrefixLength)
        $Property = @{
            Status       = 'Successful'
            NATAdapterIP = $NATAdapterIP
            Nat          = $NAT
        }
    
    }

    Catch {

        $Property = @{
            Status       = 'Unsuccessful'
            NATAdapterIP = 'Null'
            Nat          = 'Null'
        }

    }

    Finally { 

        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object

    }

}

End { }