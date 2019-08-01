<#
To-do: Add email logging option, generate alert numbers based on error info. Write to the event log of a remote computer.
#>

Function New-WE_LogError {

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

                $EventLog = "Unable to log error ($Error)."

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