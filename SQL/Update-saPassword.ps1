$User = ""

$SQL_Credential = Read-Host -AsSecureString

sqlcmd -Q "ALTER LOGIN $User WITH PASSWORD = '$SQL_Credential'"