Function Get-WE_CommonTransportDetail {

    <#

    .SYNOPSIS
        Perform a lookup of common TCP and UDP ports.

    .DESCRIPTION
        Supports the common transport protocols and ports used for the

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -
        To Do:
            -Add parameter to select from individual protocols
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS> $TransportDetails = Get-WE_CommonTransportDetails
        C:\PS> $TransportDetails.SMTPPort
        25

        Description

        -----------

        Insert here.

    #>

    [Cmdletbinding(SupportsShouldProcess)]

    Param ()

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $Property = [Ordered] @{
                SMTPProtocol   = 'TCP'
                SMTPPort       = 25
                HTTPProtocol   = 'TCP'
                HTTPPort       = 80
                HTTPSProtocol  = 'TCP'
                HTTPSPort      = 443
                FTPProtocol    = 'TCP'
                FTPPort        = 20, 21
                TelnetProtocol = 'TCP'
                TelnetPort     = 23
                IMAPProtocol   = 'TCP'
                IMAPPort       = 143
                RDPProtocol    = 'TCP'
                RDPPort        = 3389
                SSHProtocol    = 'TCP'
                SSHPort        = 22
                DNSProtocol    = 'TCP', 'UDP'
                DNSPort        = 53
                DHCPProtocol   = 'UDP'
                DHCPPort       = 67, 68
                POP3Protocol   = 'UDP'
                POP3Port       = 110
            }

        }

        Catch {

            Write-Verbose "Unable to load required hash table for common TCP and UDP ports."
            $Property = @{
                Status            = 'Unsuccessful'
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
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