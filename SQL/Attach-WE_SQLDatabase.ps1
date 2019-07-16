[Cmdletbinding()]
Param (
    [String] $DatabaseName,
    [String] $DatabasePath,
    [String] $LogPath
)

Try {
    $Database = Invoke-Sqlcmd -Query "CREATE DATABASE [$DatabaseName] ON (FILENAME = "$DatabasePath"), (FILENAME = "$LogPath") FOR ATTACH;"
}

Catch { }

Finally { }