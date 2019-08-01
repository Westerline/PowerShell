Function Set-WE_ADUserPhone {

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
            -Allow configuration of multiple accounts.
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

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('LoginName', 'DisplayName')]
        [String[]]
        $UserName,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('CellPhone')]
        [String[]]
        $MobilePhone,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('Landline')]
        [String[]]
        $HomePhone,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('WorkPhone')]
        [String[]]
        $OfficePhone

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $ADUser = Set-ADUser -DisplayName $UserName -MobilePhone $MobilePhone -HomePhone $HomePhone -OfficePhone $OfficePhone -ErrorAction Stop
            $Property = @{
                Status      = 'Successful'
                User        = $ADUser.DisplayName
                MobilePhone = $ADUser.MobilePhone
                HomePhone   = $ADUser.HomePhone
                OfficePhone = $ADUser.OfficePhone
            }

        }

        Catch {

            Write-Verbose "Unable to set Active Directory user $UserName phone details."
            $Property = @{
                Status      = 'Unsuccessful'
                User        = $ADUser.DisplayName
                MobilePhone = $ADUser.MobilePhone
                HomePhone   = $ADUser.HomePhone
                OfficePhone = $ADUser.OfficePhone
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