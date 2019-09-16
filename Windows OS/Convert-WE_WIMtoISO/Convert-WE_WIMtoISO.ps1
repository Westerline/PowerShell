Function Convert_WE_WIMtoISO {

    <#

    .SYNOPSIS
        Converts a WIM to an ISO file.

    .DESCRIPTION
        This specifies the source and the destination for the iso. The source must be a folder which contains the WIM file for this script to work in Windows Deployment Toolkit.
        -n Permits file names longer than DOS 8.3 file names.
        -d Permits lower-case file names
        -m ignores the maximum size limit of an image

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

    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [String]
        $Source,

        [Parameter(Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [ValidateScript( { $_.EndsWith('.iso') })]
        [String]
        $Destination

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $oscdimg = & "$PSScriptRoot\oscdimg\oscdimg.exe" -n -d -m $Source $Destination
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                Status  = 'Successful'
                oscdimg = $oscdimg
            }

        }

        Catch {

            Write-Verbose "Unable to convert $Source to ISO."
            $Property = @{
                Status            = 'Unsuccessful'
                Source            = $Source
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