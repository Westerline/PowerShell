New-Item -Path "D:\MDT" -ItemType directory
New-SmbShare -Name "DeploymentShare$" -Path "D:\MDT" -FullAccess Administrators
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "D:\MDT" -Description "MDT Deployment Share (Tutorial)" -NetworkPath "\\$Env:ComputerName\DeploymentShare$" -Verbose | add-MDTPersistentDrive -Verbose