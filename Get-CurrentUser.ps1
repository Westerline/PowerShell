#Use the below function to get the name of a currently logged on user.

$Name = "Test"

$Computers = Get-ADComputer -Filter Name -Like $Name | Sort-Object -Property Name | Select-Object -ExpandProperty Name
foreach ($Computer in $Computers) {
    Try {
        Get-WmiObject -ComputerName $Computer -Class Win32_ComputerSystem -ErrorAction Stop | Select Name, Username, DNSHostName
    }
    Catch {
        Write-Output "$Computer not found."
    }
}