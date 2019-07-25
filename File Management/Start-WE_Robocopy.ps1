<#
-MIR: Mirror a directory tree
-COPY: Copy-only
-MOVE: Move files and directories (delete from source after copying).
-IPG: Inter-packet gap (ms), to free bandwidth on slow lines
-MT: Do multi-threaded copies with $MT threads (default 8). $MT must be at least 1 and not greater than 128.

To-do: Add $LastExitCode variable for error handling (https://blogs.msdn.microsoft.com/kebab/2013/06/09/an-introduction-to-error-handling-in-powershell/). Base robocopy statement which is appended with parameters based on switch statement. Create separate validate sets for IPG and MT. Other optional parameters.
#>

[CmdletBinding(DefaultParameterSetName = 'Default',
    SupportsShouldProcess)]

Param (

    [Parameter(Mandatory = $True,
        Position = 0,
        ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'IPG')]
    [Parameter(ParameterSetName = 'MT')]
    [ValidateSet('MIR_IPG', 'MIR_MT', 'COPY_IPG', 'COPY_MT', 'MOVE_IPG', 'MOVE_MT', 'J')] 
    [String[]] 
    $Type,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'IPG')]
    [Parameter(ParameterSetName = 'MT')]
    [validatenotnullorempty()] 
    [String]
    $Source,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'IPG')]
    [Parameter(ParameterSetName = 'MT')]
    [validatenotnullorempty()] 
    [String]
    $Destination,

    [Parameter(ParameterSetName = 'IPG')]
    [validatenotnullorempty()] 
    [Int] 
    $IPG = 2,

    [Parameter(ParameterSetName = 'MT')]
    [validatenotnullorempty()] 
    [Int]
    $MT = 8

)

Try {

    $Parameter = @()

    Switch ( $Type ) {
        'MIR_IPG' { $Parameter += "/MIR", "/IPG:$IPG" }
        'MIR_MT' { $Parameter += "/MIR", "/MT:$MT" }
        'COPY_IPG' { $Parameter += "/COPY:DAT", "/IPG:$IPG" }
        'COPY_MT' { $Parameter += "/COPY:DAT", "/MT:$MT" }
        'MOVE_IPG' { $Parameter += "/MOVE", "/IPG:$IPG" }
        'MOVE_MT' { $Parameter += "/MOVE", "/MT:$MT" }
    }

    Robocopy.exe $Source $Destination /E @Parameter

}

Catch { }

Finally { }