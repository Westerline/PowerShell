[Cmdletbinding()]

Param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()] 
    [Alias('HostName')]
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