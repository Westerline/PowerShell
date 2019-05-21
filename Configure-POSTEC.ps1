Start-Transcript -Path 'C:\temp\Configure-POSTEC.txt'  -Append -Force


Try {

    #Define Variables

    [int]$StoreNumber = $env:COMPUTERNAME.Substring(0, 3)

    $StationNumber = $env:COMPUTERNAME.Substring(6, 2)

    #Configure Required POSTEC settings


    
    If ((Test-Connection -Quiet -Count 2 -ComputerName ('192.192.' + $StoreNumber + '.210')) -or (Test-Connection -Quiet -Count 2 -ComputerName '192.168.4.1')) {

    
    
        Write-Output 'Fuel Site Detected' -Verbose                                                                                                                                                          

        Get-Service -Name *Firebird* | Set-Service -StartupType Automatic -Verbose

        Get-Service -Name *Firebird* | Start-Service -Verbose
    
    
    
        #Configure PCC Connection Wizard
        
        #PCC IP

        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Postec\FOCUS\Client DLL\PCC\Network Settings' -Name 'IP Address' -Value ('192.192.' + $StoreNumber + '.210') -Verbose

        #Features
            
        #Define POSTEC registry key values for the following applications, Forecourt Configuration, Forecourt Manager, and Visual Console

        Switch ($StationNumber) {
            
            '01' { $FC = '1'; $FM = '2'; $VC = '3' }

            '02' { $FC = '4'; $FM = '5'; $VC = '6' }

            '03' { $FC = '10'; $FM = '11'; $VC = '12' }

        }


        #Forecourt Configuration
        
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Postec\FOCUS\Forecourt Configuration\Communication Settings' -Name 'Client Node Address' -Value $FC -Verbose -Force

        
        #Forecourt Manager

        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Postec\FOCUS\Forecourt Manager\Communication Settings' -Name 'Client Node Address' -Value $FM -Verbose -Force

        
        #Visual Console

        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Postec\FOCUS\Visual Console\Communication Settings' -Name 'Client Node Address' -Value $VC -Verbose -Force


    }



    Else {

        Write-Output 'Non-fuel Site Detected' -Verbose

        If ( Test-Path 'C:\Users\Public\Desktop\VisualConsole.lnk') { Remove-Item -Path 'C:\Users\Public\Desktop\VisualConsole.lnk' -Force -Verbose }

    }

}



Catch {

    Write-Warning 'The POSTEC settings were not configured successfully. Please refer to the supplied documentation and configure these settings manually.' -Verbose

}


Stop-Transcript | Out-Null