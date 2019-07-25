﻿[CmdletBinding()]

Param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [validatenotnullorempty()] 
    [Alias('Pattern')]
    [String[]]
    $String 
)

Foreach ($Str in $String) {

    $Boolean = "$Str" -match "^[\d\.]+$"
    $Property = @{
        String  = "$Str"
        Numeric = "$Boolean"
    }

    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object

}