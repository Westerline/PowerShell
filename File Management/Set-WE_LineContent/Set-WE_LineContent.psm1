Function Set-WE_LineContent {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Command description here.

    .PARAMETER
        -Pattern [<String>]
            Pattern parameter will append wildcards to either side of the input.

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

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [Alias('FileName')]
        [String[]]
        $Path,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [validatenotnullorempty()]
        [String]
        $Pattern,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 2)]
        [validatenotnullorempty()]
        [String]
        $Value,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($P in $Path) {

            Try {

                $ErrorActionPreference = 'Stop'
                $Content = Get-Content -Path $P -Force:$Force 

                Switch ($Content.ReadCount.Count) {

                    {!($Content | Select-String -Pattern "$Pattern")} {

                        Write-Verbose "No strings found matching the pattern $Pattern on the input file $P."
                        $OldLine = $Content
                        $Property = [Ordered] @{
                            "Status" = "No changes have been made to the file."
                            "Path" = "$P"
                        }

                    }

                    {($_ -le 1) -and ($Content | Select-String -Pattern "$Pattern")} {

                        $OldLine = $Content
                        $Content = $Value
                        Set-Content -Path $P -Value $Content
                        $Property = [Ordered] @{
                            "Status" = "Changes have been made to the file."
                            "Path" = "$P"
                            "OldLine" = "$OldLine"
                            "NewLine" = "$Value"
                        }

                    }

                    {($_ -gt 1) -and ($Content | Select-String -Pattern "$Pattern")} {

                        $LineNumber = ($Content | Select-String -Pattern "$Pattern" | Select-Object -ExpandProperty LineNumber)

                        $Property = [Ordered] @{
                            "Status" = "Changes have been made to the file."
                            "Path" = "$P"
                        }
                        Foreach ($Line in $LineNumber) {
                            $LineIndex = $Line - 1
                            $OldLine = $Content[$LineIndex]
                            $Content[$LineIndex] = $Value
                            $Property += [Ordered] @{
                                "OldLine[$LineIndex]" = "$OldLine" 
                                "NewLine[$LineIndex]" = "$Value"
                            }
                        }

                        Set-Content -Path $P -Value $Content                       
                        
                    }

                }

                $ErrorActionPreference = $StartErrorActionPreference

            }

            Catch {

                Write-Verbose "Unable to get set line content for $P."
                $Property = @{
                    Status            = 'Unsuccessful'
                    Path              = $P
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                }

            }

            Finally {

                $Object = New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}