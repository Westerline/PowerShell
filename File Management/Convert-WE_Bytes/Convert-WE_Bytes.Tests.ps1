#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a module for all needed components
.EXAMPLE
    Invoke-Pester
.NOTES
    This is a very generic set of tests that should apply to all modules.
#>


$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Module = Split-Path -Leaf $Here

Describe "Module: $Module" -Tags Unit {

    Context "Module Configuration" {

        It "Has a root module file ($Module.psm1)" {

            "$Here\$Module.psm1" | Should -Exist

        }

        It "Has a manifest file ($Module.psd1)" {

            "$Here\$Module.psd1" | Should -Exist

        }

        It "Has a Pester test" {

            "$Here\$Module.tests.ps1" | Should -Exist

        }


        It "Contains a root module path in the manifest (RootModule = '.\$Module.psm1')" {

            "$Here\$Module.psd1" | Should -Exist
            "$Here\$Module.psd1" | Should -FileContentMatch "\.\\$Module.psm1"

        }

        It "Can be imported" {

            { Import-Module "$Here\$Module.psd1" } | Should -Not -Throw

        }

    }

    Context "Build Tests" {

        It "Is valid Powershell (Has no script errors)" {

            $Contents = Get-Content -Path "$Here\$Module.psm1" -ErrorAction Stop
            $Errors = $Null
            $Null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
            $Errors | Should -HaveCount 0
        }

        It "Has show-help comment block" {

            "$Here\$Module.psm1" | Should -FileContentMatch '<#'
            "$Here\$Module.psm1" | Should -FileContentMatch '#>'
        }

        It "Has show-help comment block has a synopsis" {

            "$Here\$Module.psm1" | Should -FileContentMatch '\.SYNOPSIS'
        }

        It "Has show-help comment block has an example" {

            "$Here\$Module.psm1" | Should -FileContentMatch '\.EXAMPLE'
        }

        It "Is an advanced function" {

            "$Here\$Module.psm1" | Should -FileContentMatch 'function'
            "$Here\$Module.psm1" | Should -FileContentMatch 'cmdletbinding'
            "$Here\$Module.psm1" | Should -FileContentMatch 'param'
        }

        It "Has Begin/Process/End blocks" {

            "$Here\$Module.psm1" | Should -FileContentMatch 'begin'
            "$Here\$Module.psm1" | Should -FileContentMatch 'process'
            "$Here\$Module.psm1" | Should -FileContentMatch 'end'
        }

        It "Has Try/Catch/Finally blocks" {

            "$Here\$Module.psm1" | Should -FileContentMatch 'try'
            "$Here\$Module.psm1" | Should -FileContentMatch 'catch'
            "$Here\$Module.psm1" | Should -FileContentMatch 'finally'
        }

        It "Has error action preferences" {

            "$Here\$Module.psm1" | Should -FileContentMatch "$($StartErrorActionPreference)"

        }

        It "Explicitly writes the object to output" {

            "$Here\$Module.psm1" | Should -FileContentMatch "Write-Output $($Object)"

        }

    }

    Context "Function Tests: $Module" {

        It "Output is of hash table type" {

            Convert-WE_Bytes -Value 5 -From MB -To GB | Should -BeOfType System.Collections.Hashtable

        }

        It "Converts Bytes to any other Unit" {

            (Convert-WE_Bytes -Value 10 -From B -To B).Value | Should Be 10
            (Convert-WE_Bytes -Value 10 -From B -To B).Unit | Should Be "B"

            (Convert-WE_Bytes -Value 100 -From B -To KB).Value | Should Be .1
            (Convert-WE_Bytes -Value 100 -From B -To KB).Unit | Should Be "KB"

            (Convert-WE_Bytes -Value 10000000 -From B -To MB).Value | Should Be 10
            (Convert-WE_Bytes -Value 10000000 -From B -To MB).Unit | Should Be "MB"

            (Convert-WE_Bytes -Value 1000000000 -From B -To GB).Value | Should Be 1
            (Convert-WE_Bytes -Value 1000000000 -From B -To GB).Unit | Should Be "GB"

            (Convert-WE_Bytes -Value 1000000000000 -From B -To TB).Value | Should Be 1
            (Convert-WE_Bytes -Value 1000000000000 -From B -To TB).Unit | Should Be "TB"

        }

        It "Converts Kilobytes to any other Unit" {

            (Convert-WE_Bytes -Value 10 -From KB -To B).Value | Should Be 10000
            (Convert-WE_Bytes -Value 10 -From KB -To B).Unit | Should Be "B"

            (Convert-WE_Bytes -Value 100 -From KB -To KB).Value | Should Be 100
            (Convert-WE_Bytes -Value 100 -From KB -To KB).Unit | Should Be "KB"

            (Convert-WE_Bytes -Value 10000000 -From KB -To MB).Value | Should Be 10000
            (Convert-WE_Bytes -Value 10000000 -From KB -To MB).Unit | Should Be "MB"

            (Convert-WE_Bytes -Value 1000000000 -From KB -To GB).Value | Should Be 953.6
            (Convert-WE_Bytes -Value 1000000000 -From KB -To GB).Unit | Should Be "GB"

            (Convert-WE_Bytes -Value 1000000000000 -From KB -To TB).Value | Should Be 931
            (Convert-WE_Bytes -Value 1000000000000 -From KB -To TB).Unit | Should Be "TB"

        }

        <#
        It "Converts Kilobytes to any other Unit" { }

        It "Converts Megabytes to any other Unit" { }

        It "Converts Gigabytes to any other Unit" { }

        It "Converts Terabytes to any other Unit" { }

        It "Converts multiple values" { }
        #>

    }

}
