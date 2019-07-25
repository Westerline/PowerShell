[CmdletBinding()]

param (
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [validatenotnullorempty()] 
    [Alias('FileName')]    
    [String[]]
    $Path
)

$FileName = Get-ChildItem -File -Path $Path | Where-Object { $_.VersionInfo.FileVersion -ne $Null }

Foreach ($File in $FileName) {

    $Property = @{               
        FullName    = $File.FullName
        FileVersion = $File.VersionInfo.FileVersion
    }

    $Object = New-Object -TypeName PSObject -Property $Property
    Write-Output $Object

}