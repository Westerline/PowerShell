$Computers = 
$Credentials = (Get-Credential -Message 'Please enter the required credentials.')

Invoke-Command -Session $Sessions -ScriptBlock {

        $Process = Get-WmiObject -Class Win32_Process -Filter "Name like '%Test%'"

        $Name = $Process.Name

        $Owner = $Process.GetOwner() | Select-Object -ExpandProperty User
    
        Write-Output "","$Env:Computername is running $Name with the owner $Owner",""

    }

Remove-PSSession -Session $Sessions