<#
.Resources
    Adapted from: https://www.windowscentral.com/how-export-and-import-scheduled-tasks-windows-10
.To Do
    Add Switch {} statement for non-user/password version of command.
#>
Param (
    [String] $FilePath,
    [String] $Name,
    [String] $TaskPath
)

Begin { }

Process {
    
    Try {

        $Task = Export-ScheduledTask -TaskName $Name -TaskPath $TaskPath | Out-File -FilePath $FilePath
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