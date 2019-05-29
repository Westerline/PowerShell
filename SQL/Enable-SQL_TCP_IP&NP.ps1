#Script provided by Microsoft Docs @ https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/dd206997(v=sql.105)

Start-Transcript -Path 'C:\temp\Enable-TCP_IP&NP.txt'


# Load the assemblies and modules
Import-Module "sqlps" -DisableNamechecking
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")

$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = New-Object ($smo + 'Wmi.ManagedComputer').

# List the object properties, including the instance names.
$Wmi

# Enable the TCP protocol on the default instance.
$uri = "ManagedComputer[@Name='<computer_name>']/ ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Tcp']" 
$Tcp = $wmi.GetSmoObject("$uri")
$Tcp.IsEnabled = $true
$Tcp.Alter()
$Tcp

# Enable the named pipes protocol for the default instance.
$uri = "ManagedComputer[@Name='<computer_name>']/ ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Np']"
$Np = $wmi.GetSmoObject("$uri")
$Np.IsEnabled = $true
$Np.Alter()
$Np

Restart-Service -Name MSSQLSERVER -Force -Verbose


Stop-Transcript | Out-Null