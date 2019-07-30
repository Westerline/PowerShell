<#
.Notes
    To Do: (1) Allow setting of multiple accounts.
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
        $ADUser = Set-ADUser -DisplayName $UserName -MobilePhone $MobilePhone -HomePhone $HomePhone -OfficePhone $OfficePhone
        $Property = @{
            Status      = 'Successful'
            User        = $ADUser.DisplayName
            MobilePhone = $ADUser.MobilePhone
            HomePhone   = $ADUser.HomePhone
            OfficePhone = $ADUser.OfficePhone
        }
    }

    Catch { 
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