<#
.SYNOPSIS
    Configure an existing VM Switch

.DESCRIPTION
    The following details how to create an isolated NAT'd network between your LAN, VM Server, and VM Clients
    The newly created VM switch is assigned an IP in a different network than your LAN, i.e. 192.168.0.1, we then create a NAT between the physical NIC and this virtual NIC.
    NAT rules can be configured as well.
    In the simple NAT rule example, 0.0.0.0 is used to specify all NIC IP addresses on the host. To connect to the VM from a different PC on the same LAN as your VM host:
    enter the VM host's IP address and the external port used. Note: this limits the virtual switch to a single, in this example, web server listening on TCP port 80.
    In the RDP example, 0.0.0.0 is used to specify all NIC IP addresses on the host. To connect to the VM from a different PC on the same LAN as your VM host:
    enter the VM host's IP address and the external port used e.g. 10.1.1.2:50002.We can have several different VM hosts with port forwarding to RDP on the same VM switch.
    

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
    Example 1: Simple NAT
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------
    Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 80 -Protocol TCP -InternalIPAddress "192.168.0.4" -InternalPort 80 -NatName NATNetwork

    Example 2: RDP
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------
    Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 80 -Protocol TCP -InternalIPAddress "192.168.0.4" -InternalPort 80 -NatName NATNetwork
 
.NOTES
    Author: Wesley Esterline
    Resources: 
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
#>

[CmdletBinding()]

Param (

    [Parameter(Mandatory = $False)]
    [Alias('Transcript')]
    [string]$TranscriptFile

)

Begin {
    Start-Transcript $TranscriptFile  -Append -Force
    $StartErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

}

Process {

    Try {

        New-VMSwitch -SwitchName “NATSwitch” -SwitchType Internal

        New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceAlias “vEthernet (NATSwitch)”

        New-NetNAT -Name “NATNetwork” -InternalIPInterfaceAddressPrefix 192.168.0.0/24
       
    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}