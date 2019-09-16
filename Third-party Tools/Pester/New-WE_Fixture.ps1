Function New-WE_Fixture {

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
            -Add second catch block for Get-ChildItem command.
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

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [String[]]
        $Path,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [validatenotnullorempty()]
        [String]
        $Filter

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        $Modules = Get-ChildItem $Path -Filter $Filter -Recurse -ErrorAction Stop

        Foreach ($Module in $Modules) {

            Try {

                $Fixture = New-Fixture -Path $Module.DirectoryName -Name $Module.Name -ErrorAction Stop
                $Property = @{
                    Stauts        = 'Successful'
                    Fixture       = $Fixture
                    DirectoryName = $Module.DirectoryName
                    Name          = $Moodule.Name
                }

            }

            Catch {

                $Property = @{
                    Stauts            = 'Unsuccessful'
                    Computername      = $Env:COMPUTERNAME
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                    Position          = $_.InvocationInfo.PositionMessage
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