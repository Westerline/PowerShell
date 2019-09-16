Function New-WE_SelfSignedCodeCertificate {

    <#

    .SYNOPSIS
        Synopsis here

    .DESCRIPTION
        Generates self-signed powershell code signing certificate. Should only be used in test environments.
        Certificate must be moved to the local machine's trusted root and trusted publisher stores for the code to be executed.

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
            -Modified from https://blogs.u2u.be/u2u/post/creating-a-self-signed-code-signing-certificate-from-powershell
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

    [Cmdletbinding(SupportsShouldProcess)]

    Param(

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $Duration = 3,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Subject = "PowerShell Code Signing Certificate",

        [Parameter(Mandatory = $False,
            ValueFromPipelineByPropertyName = $True,
            Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CertStoreLocation = "Cert:\LocalMachine\My",

        [Parameter(Mandatory = $False)]
        [Switch]
        $Force

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ErrorActionPreference = 'Stop'
            $NotAfter = $([datetime]::now.AddYears($Duration))
            $Certificate = New-SelfSignedCertificate -Subject $Subject -Type CodeSigningCert -NotAfter $NotAfter -CertStoreLocation $CertStoreLocation
            $TrustedRoot = Copy-Item -Path $Certificate.PSPath -Destination "Cert:\LocalMachine\Root" -Force:$Force
            $TrustedPublisher = Move-Item -Path $Certificate.PSPath -Destination "Cert:\LocalMachine\TrustedPublisher" -Force:$Force
            $ErrorActionPreference = $StartErrorActionPreference
            $Property = @{
                Thumbprint       = $Certificate.Thumbprint
                TrustedRoot      = $TrustedRoot
                TrustedPublisher = $TrustedPublisher
            }

        }

        Catch {

            Write-Verbose "Unable to create self-signed coding certificate. Verify you have permissions to write to the root certificate store."
            $Property = @{
                Status            = 'Unsuccessful'
                ComputerName      = $Env:COMPUTERNAME
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