Function New-WE_LogError {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

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
            -Add email logging option
            -Generate alert numbers based on error info
            -Write to the event log of a remote computer
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [Cmdletbinding()]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $EventID,

        [ValidateNotNullOrEmpty()]
        [String]
        $LogName = 'Windows PowerShell'

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Err in $Error) {

            Try {

                $Message = "$Err.Exception"
                Write-EventLog -EventId $EventID -LogName 'Windows PowerShell' -Source 'PowerShell' -Message $Message -EntryType Error -ErrorAction Stop
                $EventLog = "Sucessfully logged error ($Error)."

            }

            Catch {

                $EventLog = @{
                    Status            = 'Unsuccessful'
                    Error             = $Err
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                }

            }

            Finally {

                Write-Output $EventLog

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}