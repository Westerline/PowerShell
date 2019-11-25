#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a module for all needed components
.EXAMPLE
    Invoke-Pester
.NOTES
    This is a very generic set of tests that should apply to all modules.
    Manual Test 1: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort AD
    Manual Test 2: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort SMTP
    Manual Test 3: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort HTTP
    Manual Test 4: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort HTTPS
    Manual Test 5: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort FTP
    Manual Test 6: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort Telnet
    Manual Test 7: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort IMAP
    Manual Test 8: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort RDP
    Manual Test 9: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort SSH
    Manual Test 10: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort DNS
    Manual Test 11: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort DHCP
    Manual Test 12: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort POP3
    Manual Test 13: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -CommonPort PortRange -PortRange 65534:65535
    Manual Test 14: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -Protocol Both -Port 80
    Manual Test 14: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -Protocol TCP -Port 81
    Manual Test 14: Test-WE_Port -HostName 8.8.8.8, 1.1.1.1, 1.0.0.1 -Protocol UDP -Port 82
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
