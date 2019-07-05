<#
Pattern parameter will append wildcards to either side of the input.
#>

Param(
    [String] $Path,
    [String] $Pattern,
    [String] $Value
)

Try {
    $Content = Get-Content -Path $Path

    $LineIndex = ($Content | Select-String -Pattern "$Pattern" | Select-Object -ExpandProperty LineNumber) - 1

    $Content[$LineIndex] = $Value

    Set-Content -Path $Path -Value $Content

    $Property = @{
        Path       = $Path
        NewContent = $Content[$LineIndex]
    }
}

Catch {
    $Property = @{
        Path       = $Path
        NewContent = 'Null'
    }
}

Finally {
    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}