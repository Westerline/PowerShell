#Create Registry Value for Remote File Share and PSEXEC
#Set to 1 for Disable (no remote admin share allowed), Set to 0 for Enable (remote admin share allowed). Be warned only use this setting if absolutely required and you understand the implications.
Get-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" | New-ItemProperty -Name LocalAccountTokenFilterPolicy -Value 1 -PropertyType Dword
pause