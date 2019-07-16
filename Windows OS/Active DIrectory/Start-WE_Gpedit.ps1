Param (
    [String[]] $ComputerName
)

Foreach ($Computer in $ComputerName) {
    Try {
        & gpedit.msc /gpcomputer: $Computer
    }
    Catch { }
    Finally { }
}