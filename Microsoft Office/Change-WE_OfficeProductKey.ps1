<#
Requires -runasadministratorcls
#>
Param(
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        HelpMessage = 'Product key must match the format XXXXX-XXXXX-XXXXX-XXXXX-XXXXX')]
    [ValidatePattern('\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w-\w\w\w\w\w')]
    [String] $ProductKey
)

$ErrorActionPreference = 'SilentlyContinue'

Try {
    
    $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS'
    cscript.exe $OSPP.FullName /inpkey:$ProductKey
    cscript.exe $OSPP.FullName /act
}

Catch {

}
