#Will ping a /24 subnet. To iterate through a larger subnet such as a /16 or /18, you will need to modify the code.
$ping = New-Object System.Net.Networkinformation.Ping
100..254 | % { $ping.send(“192.168.100.$_”) | Select-Object -Property Address, Status }
