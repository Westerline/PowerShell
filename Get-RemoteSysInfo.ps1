#Function to check the system information on a remote machine. rewrite to use powershell syntax

Invoke-Command -ScriptBlock {$Env:ComputerName}