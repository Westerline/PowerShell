<#
To do: registry exporting function. Registry importing function. Backup $Path1 and $Path2 prior to deletion.
#>

[Cmdletbinding(SupportsShouldProcess)]

Param ( )

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Try {

        $Configuration = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration'
        $Connectivity = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity'
        Remove-Item -Path $Configuration, $Connectivity -Recurse
        $Property = @{
            Status       = 'Successful'
            ComputerName = $Env:COMPUTERNAME
        }

    }

    Catch [System.Management.Automation.RuntimeException] {

        Write-Verbose "Path to $Configuration or $Connectivity doesn't exist. Please reboot $Env:COMPUTERNAME to re-create the required registry keys and run the cmdlet again."
        $Property = @{
            Status       = 'Unsuccessful'
            ComputerName = $Env:COMPUTERNAME
        }

    }

    Catch {

        Write-Verbose "Unable to reset monitor configuration on $Env:COMPUTERNAME. Please ensure you have administrator access to the registry and run the cmdlet again."
        $Property = @{
            Status       = 'Unsuccessful'
            ComputerName = $Env:COMPUTERNAME
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