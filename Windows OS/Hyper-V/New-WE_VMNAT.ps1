Function New-WE_VMNAT {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        The following details how to create an isolated NAT'd network between your LAN, VM Server, and VM Clients
        The newly created VM switch is assigned an IP in a different network than your LAN, i.e. 192.168.0.1, we then create a NAT between the physical NIC and this virtual NIC.

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

        <CommonParameters>
            This cmdlet supports the common parameters: Verbose, Debug,
            ErrorAction, ErrorVariable, WarningAction, WarningVariable,
            OutBuffer, PipelineVariable, and OutVariable. For more information, see
            about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -Modified from: https://www.petri.com/create-nat-rules-hyper-v-nat-virtual-switch
        To Do:
            -Add NewSwitch logic if switch paramter enabled.
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

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

            $ErrorActionPreference = 'Stop'
            $NATAdapterIP = New-NetIPAddress -IPAddress $IPAddress -PrefixLength $PrefixLength -InterfaceAlias $InterfaceAlias
            $NAT = New-NetNat -Name $NATName -InternalIPInterfaceAddressPrefix ($NetworkAddress + '/' + $PrefixLength)
            $ErrorActionPreference = $StartErrorActionPreference
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