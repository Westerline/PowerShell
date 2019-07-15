<#
To-do: Add email logging option, generate alert numbers based on error info. Write to the event log of a remote computer.
#>

Param (

)

Try {

    $Property = @{
        PSMessageDetails      = $Error.PSMessageDetails
        Exception             = $Error.Exception
        TargetObject          = $Error.TargetObject
        Category              = $Error.CategoryInfo.Category
        Activity              = $Error.CategoryInfo.Activity
        Reason                = $Error.CategoryInfo.Reason
        FullyQualifiedErrorID = $Error.FullyQualifiedErrorID
        ErrorDetails          = $Error.ErrorDetails
    }

    New-EventLog -Source $Host.Name -LogName 'Windows PowerShell'
    Write-EventLog -EventId 69 -LogName 'Windows PowerShell' -Source $Host.Name -Message $Property -EntryType Error

}

Catch { }

Finally { }