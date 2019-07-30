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
    $EventID

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

        $Object = New-Object -TypeName PSObject -Property $Property
        #New-EventLog -Source $Host.Name -LogName 'Windows PowerShell'
        Write-EventLog -EventId $EventID -LogName 'Windows PowerShell' -Source $Host.Name -Message (Write-Output $Object) -EntryType Error

    }

    Catch { }

    Finally { }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference 
    
}