#PSEXEC PowerShell Module

$Computer = '0.0.0.0'
$Computers = Get-Content C:\Temp\Test.txt

#Create PS Drive
    $Drive = New-PSDrive -Name "ComputerName" -PSProvider FileSystem -Root "\\IPAddressorHostName\c$" -Credential Username
	
#Remove PS Drive
    Remove-PSDrive -Name $Drive

#Copy Script to remote computer
    Copy-Item -Path C:\temp\test.txt -Destination \\$Computer

#Call PSEXEC will require the PSEXEC application to be included or processed in some way, will also be worthwhile to detect between 32 and 64 bit OS
	$PSEXEC = & $Env:Sysinternals\psexec.exe \\$Computer
	

#CMD
    $CMD_Copy = $PSEXEC cmd /c C:\Temp\ChromeStandaloneSetup32.exe /Silent /Install
    $CMD_RemoteConsole =  "$PSEXEC cmd"

#PS Scripts
    $PS = $PSEXEC -i -s PowerShell C:\temp\test.ps1

#SQLCMD
    $SQLCMD = $PSEXEC SQLCMD -s .\MSSQL -i "C:\temp\test.sql"
	$SQLCMD2 = $PSEXEC SQLCMD -S localhost -Q "BACKUP DATABASE [Master] TO DISK = "C:\Temp\$Computer.BAK""
	
#Regedit
	$Regedit = $PSEXEC reg add HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /v ExecutionPolicy /t REG_SZ /d Restricted /f
