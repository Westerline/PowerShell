#Install Chocolately if required...

#Non-Proxy Install
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Installing Behind a Proxy
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))



#Install/Upgrade the Following Software: 

#Chrome
Choco Upgrade Chrome -y

#CCleaner
Choco Upgrade CCleaner -Y

#Install/Update KeePass
Choco Upgrade KeePass -Y

#Install/Update Revo
Choco Upgrade  -Y    

#Install/Update 7-Zip
Choco Upgrade 7zip -Y

#Install/Update Putty
Choco Upgrade putty -Y

#Install/Update PowerShell
Choco Upgrade Powershell -Y

#Install/Update Sysinternals
Choco Upgrade Sysinternals -Y

#Paint.Net
choco upgrade paint.net -y

#Python
Choco Upgrade python -Y

#SQL
Choco Upgrade sql-server-management-studio

#WSUS Offline Update
Choco Upgrade wsus-offline-update

#Choco 