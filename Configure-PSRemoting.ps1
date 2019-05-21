#Remote Endpoint Configuration
    
    #Step 1: Local Account Token
    New-ItemProperty -Name LocalAccountTokenFilterPolicy -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -PropertyType DWord -Value 1

    #Step 2: Enable-PSRemoting
    Enable-PsRemoting -Force

    #Step 3: Enable Legacy HTTP Listener on Port 80 (Optional)
    Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpListener -value True

    

#Client-side

    #Configure the machines you the client can remote to.

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.10.10.3"

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "PC4" -Concatenate

 

#Example Non-domain Connection

    $SERVER = 'REMOTE_SERVER'

    $USER   = 'REMOTE_USER'

    New-PSSession -ComputerName $Server -Name 'PC3' -Credential (get-credential "$USER") -Port 80

    Enter-PSSession -ComputerName $SERVER

    Invoke-Command -Computer $SERVER -Credential (get-credential "$USER") { ls C:\ } -port 80