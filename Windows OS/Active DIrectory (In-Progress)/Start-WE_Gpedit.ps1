Param (
    [String[]] $ComputerName
)

Begin { }

Process {
    Foreach ($Computer in $ComputerName) {
        Try {
            & gpedit.msc /gpcomputer: $Computer
        }
        Catch { }
        Finally { }
    }
}

End { }