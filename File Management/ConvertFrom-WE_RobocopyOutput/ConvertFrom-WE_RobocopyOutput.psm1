Function ConvertFrom-WE_RobocopyOutput {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
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

    .PARAMETER
        -ParameterName [<String[]>]
            Parameter description here.

            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       false
            Accept wildcard characters?  false

        <CommonParameters>
            This cmdlet supports the common parameters: Verbose, Debug,
            ErrorAction, ErrorVariable, WarningAction, WarningVariable,
            OutBuffer, PipelineVariable, and OutVariable. For more information, see
            about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    .INPUTS
        System.String[]
            Input description here.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Version: 1.0
        Author(s): Wesley Esterline
        Resources:
            -
        To Do:
            -
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding()]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [Alias('FileName', 'FullName', 'Path')]
        [AllowEmptyString()]
        [String[]]
        $InputObject

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $Robo_Content = $InputObject -match '^(?= *?\b(Source|Dest|Started|Total|Dirs|Files|Ended)\b)((?!    Files).)*$'
            $ErrorActionPreference = $StartErrorActionPreference
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
                Status            = 'Unsuccessful'
                InputObject       = $InputObject
                ExceptionMessage  = $_.Exception.Message
                ExceptionItemName = $_.Exception.ItemName
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}