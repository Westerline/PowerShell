<#
To-do: Add email logging option, generate alert numbers based on error info. Write to the event log of a remote computer.
#>

[Cmdletbinding(SupportsShouldProcess)]

Param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Int]
    $EventID,

    [ValidateNotNullOrEmpty()]
    [String]
    $LogName = 'Windows PowerShell'

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

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

    }

    Catch {

        Write-Verbose "Unable to log error ($Error)."
        $Property = @{
            PSMessageDetails      = 'Null'
            Exception             = 'Null'
            TargetObject          = 'Null'
            Category              = 'Null'
            Activity              = 'Null'
            Reason                = 'Null'
            FullyQualifiedErrorID = 'Null'
            ErrorDetails          = 'Null'
        }

    }

    Finally {

        $Object = New-Object -TypeName PSObject -Property $Property
        Write-EventLog -EventId $EventID -LogName 'Windows PowerShell' -Source $Host.Name -Message (Write-Output $Object) -EntryType Error

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference

}