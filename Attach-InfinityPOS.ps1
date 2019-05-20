#Script to automatically attach the required database and configure required users.

Start-Transcript 'C:\temp\Attach-Database.txt' -Append -Force

Try {

    If (Test-Path 'C:\Database\Data\data.mdf') {

        Write-Output "Database file found." -Verbose

        Invoke-Sqlcmd -Query "CREATE DATABASE AKPOS ON (FILENAME = 'C:\Database\Data\data.mdf'), (FILENAME = 'C:\Database\Data\log.ldf') FOR ATTACH;" -Verbose

        Invoke-Sqlcmd -Query "CREATE LOGIN User WITH PASSWORD = $SecureString;" -Verbose

        Invoke-Sqlcmd -Query "EXEC master..sp_addsrvrolemember @loginame = N'User', @rolename = N'public';" -Verbose

        Write-Output "Database setup and configured." -Verbose

    }

    Else {

        Write-Warning "Database file not found." -Verbose

    }

}


Catch {

    Write-Warning 'A generic error occurred when attaching and configuring the database.' -Verbose
}


Stop-Transcript | Out-Null