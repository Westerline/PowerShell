<#
This function is used to test redirection of different output streams.
Resources: https://blog.simonw.se/programmatically-capture-verbose-output-in-a-powershell-variable/
*	All output
1	Success output
2	Errors
3	Warning messages
4	Verbose output
5	Debug messages
6   Informational messages
#>

function Write-WE_Stream {

    [cmdletbinding()]
    Param()
    
    Begin {
        $OldVerbosePreference = $VerbosePreference
        $OldDebugPreference = $DebugPreference
        $VerbosePreference = 'Continue'
        $DebugPreference = 'Continue'
    }

    Process {
        Write-Host "This is written to host" -ForegroundColor Green
        Write-Output "This is written to Success output"
        Write-Error "This is an error"
        Write-Warning "This is a warning message"
        Write-Verbose "This is verbose output"
        Write-Debug "This is a debug message"
        Write-Information "This is an informational message"
    }

    End { 
        $VerbosePreference = $OldVerbosePreference
        $DebugPreference = $OldDebugPreference
    }

}