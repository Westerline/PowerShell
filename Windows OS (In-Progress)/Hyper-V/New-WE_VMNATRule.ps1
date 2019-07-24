<#
.SYNOPSIS


.DESCRIPTION
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
    Resources: https://www.petri.com/create-nat-rules-hyper-v-nat-virtual-switch
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
#>

Param (

)

Begin { }

Process {

    Try {

        Switch ($CommonPort) {
            SMTP {
                $Port = 25
                $Protocol = 'TCP' 
            }
            HTTP {
                $Port = 80
                $Protocol = 'TCP' 
            }
            HTTPS {
                $Port = 443
                $Protocol = 'TCP' 
            }
            FTP {
                $Port = 21 
                $Protocol = 'TCP' 
            }
            Telnet {
                $Port = 23 
                $Protocol = 'TCP' 
            }
            IMAP {
                $Port = 143 
                $Protocol = 'TCP' 
            }
            RDP {
                $Port = 3389 
                $Protocol = 'TCP'
            }
            SSH {
                $Port = 22
                $Protocol = 'TCP' 
            }
            DNS {
                $Port = 53 
                $Protocol = 'UDP' 
            }
            DHCP {
                $Port = 68 
                $Protocol = 'UDP' 
            }
            POP3 {
                $Port = 110 
                $Protocol = 'TCP' 
            }
        }

        $NetNatStaticMapping = Add-NetNatStaticMapping -ExternalIPAddress $ExternalIPAddress -ExternalPort $Port -Protocol $Protocol -InternalIPAddress $InternalIPAddress -InternalPort $Port -NatName $NatName
        $Property = @{
            Status              = 'Successful'
            NetNatStaticMapping = $NetNatStaticMapping
        }
    }

    Catch {

        $Property = @{
            Status              = 'Unsucessful'
            NetNatStaticMapping = 'Null'
        }

    }

    Finally { 

        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object

    }

}

End { }