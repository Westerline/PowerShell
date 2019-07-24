<#
.Resources
    Adapted from: https://www.windowscentral.com/how-export-and-import-scheduled-tasks-windows-10
.To Do
    Add Switch {} statement for non-user/password version of command.
#>
Param (
    [String] $Path,
    [String] $Name,
    [String] $TaskPath,
    [String] $DomainName,
    [String] $User,
    [String] $Password
)

Begin { }

Process {
    
    Try {

        $Task = Register-ScheduledTask -Xml (Get-Content -Path $Path | Out-String) -TaskName $Name -TaskPath $TaskPath -User $DomainName\$UserName –Password $Password
        $Property = @{
            Task = $Task
        }
    }

    Catch {
        $Property = @{
            Task = 'Null'
        }
    }

    FInally {
        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object
    }

}

End { }