$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Install-WE_.Net3.5" {
    It "does something useful" {
        $true | Should -Be $false
    }
}
