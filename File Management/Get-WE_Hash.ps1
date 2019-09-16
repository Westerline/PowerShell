Function Get-WE_Hash {

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

    [cmdletbinding()]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [String []]
        $InputFile,

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160', 'All')]
        [String]
        $Algorithm = 'All'

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($File in $InputFile) {

            Try {

                $Property = [Ordered]@{
                    File = $File
                }

                If ($Algorithm -eq 'All') {

                    $Algorithm = 'SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160'

                }

                Foreach ($Alg in $Algorithm) {

                    $Hash = Get-FileHash -Path $File -Algorithm $Alg -ErrorAction Stop
                    $Property += @{
                        $Alg = $Hash.Hash
                    }

                }

            }

            Catch [System.Management.Automation.ItemNotFoundException] {

                Write-Verbose "Cannot find path $File."
                $Property += @{
                    Status            = 'Unsuccessful'
                    File              = $File
                    ExceptionMessage  = $_.Exception.Message
                    ExceptionItemName = $_.Exception.ItemName
                }

            }

            Catch {

                Write-Verbose "Could not get the hash on $File. Please ensure the path to the file is correct and try again."
                $Property += @{
                    Status            = 'Unsuccessful'
                    File              = $File
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