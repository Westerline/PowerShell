<#
.Resources
    Adapted from: https://www.windowscentral.com/how-export-and-import-scheduled-tasks-windows-10
.To Do
    Add Switch {} statement for non-user/password version of command. (2) Password parameter secure string conversion to plain text.
#>

[Cmdletbinding(SupportsShouldProcess)]

Param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $Path,

    [Parameter(Mandatory = $True)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $Name,

    [Parameter(Mandatory = $False)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $TaskPath,

    [Parameter(ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $DomainName = '.',

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $User,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $Password

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {
    
    Try {

        $Task = Register-ScheduledTask -Xml (Get-Content -Path $Path | Out-String) -TaskName $Name -TaskPath $TaskPath -User $DomainName\$UserName –Password $Password
        $Property = @{
            Task = $Task
        }
    }

    Catch {
        $Property = @{
            Task = 'Null'
        }
    }

    FInally {
        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object
    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference 

}