$LogPath1 = "$env:HOMEDRIVE\temp\ProxySettings.txt"

    



Try {
    $regKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -path $regKey ProxyEnable -value 1 -ErrorAction Stop
    $regKey_Status = Get-ItemProperty -path $regKey ProxyEnable -ErrorAction Stop
    $Properties = [Ordered] @{
        ComputerName = ($Env:COMPUTERNAME)
        ProxyEnable  = ($regKey_Status.ProxyEnable)
    }
}
Catch {

    $Properties = [Ordered] @{
        ComputerName = ($Env:COMPUTERNAME)
        Property2    = 'Test Failed'
    }
}

Finally {

    ($Object = New-Object -TypeName PSObject -Property $Properties) | Out-File $LogPath1
}