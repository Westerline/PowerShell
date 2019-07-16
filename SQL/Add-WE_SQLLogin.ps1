<#
To do: close PS session
#>

Param(
    [String] $UserName,
    [securestring] $Password,
    [String] $RoleName,
    [String] $HostName = 'LocalHost'
)

Try {
    Invoke-Sqlcmd -HostName $HostName -Query "CREATE LOGIN $UserName WITH PASSWORD = '$Password';"
    Invoke-Sqlcmd -HostName $HostName -Query "EXEC master..sp_addsrvrolemember @loginame = N'$UserName', @rolename = N'$RoleName';"
}

Catch { }

Finally { }