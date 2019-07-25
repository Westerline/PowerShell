<#
To do: registry exporting function. Registry importing function. Backup $Path1 and $Path2 prior to deletion.
#>

Begin { }

Process {

    Try {
        
        $Configuration = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration'
        $Connectivity = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity'
        Remove-ItemProperty -Path $Configuration, $Connectivity

    }


    Catch {

        "$Configuration or $Connectivity doesn't exist" 

    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}