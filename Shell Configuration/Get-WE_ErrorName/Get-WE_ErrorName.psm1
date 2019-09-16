Function Get-WE_ErrorName {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Used to find the exception name for errors. The exception name can be used in a Catch [ErrorName] {} statement.

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

    [Cmdletbinding()]

    Param (

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Int[]]
        $ErrorIndex = 0

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($E in $ErrorIndex) {

            Try {

                $ErrorActionPreference = 'Stop'
                $ErrorName = $Error[$E]
                $ErrorActionPreference = $StartErrorActionPreference
                $Property = @{
                    Status    = 'Unsuccessful'
                    Error     = $E
                    ErrorName = $ErrorName.exception.gettype().fullname
                    Activity  = $ErrorName.CategoryInfo.Activity
                }

            }

            Catch {

                Write-Verbose "Unable to capture error name. PLease try re-creating the error and rerunning this cmdlet."
                $Property = @{
                    Status            = 'Unsuccessful'
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