Function Start-WE_Robocopy {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

    .PARAMETER
        -Type [<String[]>]
            -MIR: Mirror a directory tree
            -COPY: Copy-only
            -MOVE: Move files and directories (delete from source after copying).
            -IPG: Inter-packet gap (ms), to free bandwidth on slow lines
            -MT: Do multi-threaded copies with $MT threads (default 8). $MT must be at least 1 and not greater than 128.


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
            -Create separate validate sets for IPG and MT.
        Misc:
            -

    .Example
        -------------------------- EXAMPLE 1 --------------------------

        C:\PS>WE_ModuleTemplate

        Description

        -----------

        Insert here.

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default')]

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
        [String[]]
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

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Dest in $Destination) {

            Try {

                $ErrorActionPreference = 'Stop'
                $Parameter = @()

                Switch ( $Type ) {

                    'MIR_IPG' { $Parameter += "/MIR", "/IPG:$IPG" }
                    'MIR_MT' { $Parameter += "/MIR", "/MT:$MT" }
                    'COPY_IPG' { $Parameter += "/COPY:DAT", "/IPG:$IPG" }
                    'COPY_MT' { $Parameter += "/COPY:DAT", "/MT:$MT" }
                    'MOVE_IPG' { $Parameter += "/MOVE", "/IPG:$IPG" }
                    'MOVE_MT' { $Parameter += "/MOVE", "/MT:$MT" }

                }

                $Robocopy = Robocopy.exe $Source $Dest /E @Parameter
                $ErrorActionPreference = $StartErrorActionPreference

            }

            Catch {

                Write-Verbose "Unable to execute robocopy command with the given parameters. Please check that the source and destination paths are available."
                $Robocopy = @{
                    Status            = 'Unsuccessful'
                    Destination       = $Dest
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                }

            }

            Finally {

                Write-Output $Robocopy

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}