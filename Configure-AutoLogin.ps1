Start-Transcript -Path 'C:\temp\Configure-Accounts.txt'  -Append -Force


Try {

    #Configure Autologon for the standard user account and disable the builtin administrator account.

    Remove-Item -Path 'C:\Users\Public\Desktop\*Intel*' -Force -Verbose

    #For security reasons, the built-in administrator is removed at the end of the task sequence.
    
    Disable-LocalUser -Name Administrator -Verbose

    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value '1' -Force -Verbose
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoLogonCount -Value '999' -Force -Verbose
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultDomainName -Value '.' -Force -Verbose
    New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value '' -PropertyType String -Force -Verbose
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value 'Userr' -Force -Verbose
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DisableCAD -Value '1' -Force -Verbose

}



Catch {

    Write-Warning 'The user accounts were not configured successfully.' -Verbose

}


Stop-Transcript | Out-Null