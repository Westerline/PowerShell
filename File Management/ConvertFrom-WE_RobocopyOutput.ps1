<#
Regular Expression breakdown courtesy of https://regexr.com/:
^(?= *?\b(Started|Total|Dirs|Files|Ended)\b)((?!    Files).)*$
    ^   Matches the beginning of the string, or the beginning of a line if the multiline flag (m) is enabled. This matches a position, not a character.
    (?=) Matches a group after the main expression without including it in the result.
        Matches a SPACE character
    *   Matches 0 or more of the preceding token
    ?   Makes the preceding quantifier lazy, causing it to match as few characters as possible. By default, quantifiers are greedy, and will match as many characters as possible.
    \b  Matches a word boundary position between a word character and non-word character or position (start / end of string).
    ()  Capturing group 1. Groups multiple tokens together and creates a capture group for extracting a substring or using a backreference.
    S   Matches S Character, etc.
    |   Acts like a boolean OR. Matches the expression before or after the |
    ()  Capturing group 2.
    (?!) Specifies a group that can not match after the main expression (if it matches, the result is discarded).
    .   Matches any character except line breaks
    $   Matches the end of the string, or the end of a line if the multiline flag (m) is enabled.

(?m)^\s+
    (?m) Mode Modifier
    ^   Matches the beginning of the string, or the beginning of a line if the multiline flag (m) is enabled. This matches a position, not a character.
    \s  Matches any whitespace character (spaces, tabs, line breaks)
    +   Matches 1 or more of the preceding token.
    '   Matches a """" character

To-Do: Adjust to accept pipeline input. Allow multiple file inputs.

#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [validatenotnullorempty()] 
    [Alias('FileName', 'FullName')]
    [String[]] 
    $Path
)
    
Begin { }

Process {

    Try {
        $Robo_Content = $Path -match '^(?= *?\b(Source|Dest|Started|Total|Dirs|Files|Ended)\b)((?!    Files).)*$'

        $Property = [Ordered] @{
            Status      = 'Connected'
            Started     = $Robo_Content[0] -replace 'Started :' -replace '(?m)^\s+'
            Source      = $Robo_Content[1] -replace 'Source :' -replace '(?m)^\s+'
            Destination = $Robo_Content[2] -replace 'Dest :' -replace '(?m)^\s+'
            Columns     = $Robo_Content[3] -replace '(?m)^\s+'
            Dirs        = $Robo_Content[4] -replace 'Dirs :' -replace '(?m)^\s+'          
            Files       = $Robo_Content[5] -replace 'Files :' -replace '(?m)^\s+'
            Ended       = $Robo_Content[6] -replace 'Ended :' -replace '(?m)^\s+'
        }

    }

    Catch {
        Write-Verbose "Unable to parse Robocopy output."
        $Property = [Ordered] @{
            Status      = 'Disconnected'
            Started     = 'Null'
            Source      = 'Null'
            Destination = 'Null'
            Columns     = 'Null'
            Dirs        = 'Null'        
            Files       = 'Null'
            Ended       = 'Null'
        }
    }
 
    Finally {
        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object
    }

}

End { }