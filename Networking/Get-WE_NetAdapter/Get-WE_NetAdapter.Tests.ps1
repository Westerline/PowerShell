#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a module for all needed components
.EXAMPLE
    Invoke-Pester
.NOTES
    This is a very generic set of tests that should apply to all modules.
    Test1 = Get-WE_NetAdapter
    Test 1 = Get-WE_NetAdapter -Type All
    Test2 = Get-WE_NetAdapter -Type Ethernet
    Test3 = Get-WE_NetAdapter -Type Wi-Fi
    Test4 = Get-WE_NetAdapter -Type Bluetooth
    Test5 = Get-WE_NetAdapter -Type Virtual
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

        It "explicitly writes the object to output" {

            "$Here\$Module.psm1" | Should -FileContentMatch "Write-Output $($Object)"

        }

    }

    Context "Function Tests: $Module" {

    }

}
