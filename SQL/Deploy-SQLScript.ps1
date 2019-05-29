Start-Transcript -Path "C:\temp\test.txt" -Force


#1: Load Target Machines
.\test.ps1



#2: Specify Environment Variables (Optional)
$Files = 'C:\temp\test.sql'

$LogPath1 = 'C:\temp\Deploy-Tables_Check_SQL.log'

New-Item -Path $LogPath1 -ItemType File -Force

$ErrorActionPreference = 'Continue'



$Test.GetEnumerator() | ForEach-Object {


    Try {

        $message = 'Querying {0} @ {1}...' -f $_.key, $_.value

        Write-Output $message

        $IP = $_.value

        $Station_Number = ($IP.Split('.') | Select-Object -Last 1)

 


        Copy-Item $Files -Destination "\\$IP\c$\temp\test.sql" -Force  -ErrorAction Stop
        
        PSEXEC \\$IP -accepteula -nobanner SQLCMD -s .\MSSQL -i "C:\temp\test.sql" | Format-Table -AutoSize




        $Properties = [Ordered] @{
            Computer     = $_.key
            IP           = $_.value
            Availability = 'TRUE'
            Results      = $Results
        }

    }



    Catch {

        $message = 'Failed to connect to {0} @ {1}...' -f $_.key, $_.value

        Write-Output $message

        $IP = $_.value

        $Station_Number = ($IP.Split('.') | Select-Object -Last 1)



        $Properties = [Ordered] @{
            Computer     = $_.key
            IP           = $_.value
            Availability = 'FALSE'
            Results      = 'NULL'
        }

    }



    Finally {


        ($Object = New-Object -TypeName PSObject -Property $Properties) | Out-File $LogPath1 -Append

    }

}




Stop-Transcript