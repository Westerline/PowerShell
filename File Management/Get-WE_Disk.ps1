ForEach ($Computer in $ComputerName) {

    Try {

        $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
        $LogicalDisk = Get-CimInstance -CimSession $Session -ClassName Win32_DiskDrive
        $CD = Get-CimInstance -CimSession $Session -ClassName Win32_CDROMDrive

        $Property = @{
            Computername = $ComputerName
            Stauts       = 'Connected'
            SPVersion    = $OS.ServicePackMajorVersion
            OSVersion    = $OS.Version
            Model        = $CS.Model
        }

    }

    Catch { }
    
    Finally { 

        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object
        
    }
}