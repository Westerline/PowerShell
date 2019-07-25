<#

#>

[Cmdletbinding()]

Param (
    
    [Parameter(Mandatory = $True,
        Position = 0)]
    [validateset('Ethernet', 'Wi-Fi', 'Bluetooth', 'Virtual')]  
    [String] 
    $Type

)

Begin { }

Process {

    Try {

        Switch ($Type) {
            Ethernet { $Adapter = Get-netadapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.3*' } }
            Wi-Fi { $Adapter = Get-netadapter -Physical -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*802.11*' } }
            Bluetooth { $Adapter = Get-netadapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Bluetooth*' } }
            Virtual { $Adapter = Get-netadapter -IncludeHidden | Where-Object { $_.PhysicalMediaType -like '*Unspecified*' } }
        }

    }

    Catch { 
        $Adapter = Write-Verbose "Unable to find $Type network adapter."
    }

    Finally {

        Write-Output $Adapter

    }

}

End { }