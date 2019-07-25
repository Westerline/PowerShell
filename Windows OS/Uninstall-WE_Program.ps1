[Cmdletbinding(SupportsShouldProcess)]

Param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()] 
    [Alias('ProgramName')]
    [String[]] $Name

)

Try {
 
    $Program = Get-WE_InstalledProgram | Where-Object { $_.DisplayName -eq "$Name" }
    $UninstallString = $Program.UninstallString -Replace "msiexec.exe", "" -Replace "/I", "" -Replace "/X", ""
    $UninstallArgument = $UninstallString.Trim()
    $UninstallCommand = Start-Process "msiexec.exe" -arg "/X $UninstallArgument /qb" -Wait
    $Property = @{
        Status           = 'Successful'
        UninstallCommand = $UninstallCommand
    }

}

Catch {

    $Property = @{
        Status           = 'Unsuccessful'
        UninstallCommand = 'Null'
    }

}

Finally {
    New-Object -TypeName PSObject -Property $Property
    Write-Output $Object
}