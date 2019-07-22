<#
To do: registry exporting function. Registry importing function. Backup $Path1 and $Path2 prior to deletion.
#>

Begin { }

Process {

    Try {
        
        $Path1 = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration'
        $Path2 = 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity'
        Remove-ItemProperty -Path $Path1, $Path2

    }


    Catch {

        "$Path1 or $Path2 does not exist" 

    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}