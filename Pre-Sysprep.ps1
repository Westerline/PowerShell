#Translate to PowerShell Script to run prior to using sysprep on a VM image build

@echo off
vssadmin delete shadows /All /Quiet
del c:\Windows\SoftwareDistribution\Download\*.* /f /s /q
del %windir%\$NT* /f /s /q /a:h
del c:\Windows\Prefetch\*.* /f /s /q
c:\windows\system32\cleanmgr /sagerun:1
wevtutil el 1>%Temp%\cleaneventlog.txt
for /f %%x in (%Temp%\cleaneventlog.txt) do wevtutil cl %%x
del %Temp%\cleaneventlog.txt
ipconfig /flushdns
pause