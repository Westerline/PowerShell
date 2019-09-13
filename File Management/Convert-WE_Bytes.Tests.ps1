$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$file = Get-ChildItem "$here\$sut"

Describe "Convert-WE_Bytes" {

    #This test can be used to ensure the script doesn't have any PowerShell syntax errors. Similar to a compile/build test.
    It "is valid Powershell (Has no script errors)" {

        $contents = Get-Content -Path $file -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors | Should -HaveCount 0

    }

    #This test will check if
    It "converts from one set of bytes to another (e.g. 10,000 bytes to megabytes)" {

        . "$file"
        $Bytes = Convert-WE_Bytes -Value 10000 -From B -To MB
        $Bytes | Should -MatchExactly "0.01MB"

    }

}
