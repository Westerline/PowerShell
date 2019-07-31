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
    To Do: Add NewSwitch logic if switch paramter enabled.
#>

Function New-WE_VMNAT {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('AdapterName', 'InterfaceName')]
        [String]
        $InterfaceAlias,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [String]
        $NATName,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $IPAddress,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [IPAddress]
        $NetworkAddress,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $PrefixLength

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $NATAdapterIP = New-NetIPAddress -IPAddress $IPAddress -PrefixLength $PrefixLength -InterfaceAlias $InterfaceAlias
            $NAT = New-NetNat -Name $NATName -InternalIPInterfaceAddressPrefix ($NetworkAddress + '/' + $PrefixLength)
            $Property = @{
                Status       = 'Successful'
                NATAdapterIP = $NATAdapterIP
                Nat          = $NAT
            }

        }

        Catch {

            Write-Verbose "Unable to create new VMNAT on interface $InterfaceAlias."
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

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}