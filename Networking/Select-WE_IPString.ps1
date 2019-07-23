Param (
    [String] $In
)

Try { 
    $IPString = (Select-string -InputObject $In -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value
}

Catch { }

Finally {
    Write-Output $IPString
}