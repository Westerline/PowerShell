Param(
    [String[]] $Pattern    
)

Foreach ($Pat in $Pattern) {

    $Boolean = "$Pat" -match "^[\d\.]+$"
    $Property = @{
        String  = "$Pat"
        Numeric = "$Boolean"
    }
    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}