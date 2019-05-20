Function Verify-Backup ($FilePath) {

    Start-Transcript -Path $Env:SystemDrive\Temp\Verify-Backup.txt 
                
    Invoke-Sqlcmd "Restore VERIFYONLY FROM DISK = '$FilePath'" -ErrorVariable BackupError -ErrorAction SilentlyContinue
            
    If ($BackupError -match 'VERIFY DATABASE is terminating abnormally') {

        Write-Host "Invalid Backup or an Unexpected Error Has Occurred." -ForegroundColor DarkRed -BackgroundColor DarkYellow
        $LocalBackupIntegrity = $False
    }

    Else {

        Write-Host "The backup set on file " -ForegroundColor DarkGreen -BackgroundColor Cyan
        $LocalBackupIntegrity = $False
                      
    }

    Stop-Transcript
}