#Requires -Modules Pester
#Scaffolding used to determine where the script/module files to test are located.

<#
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.ps1", ".psm1")
$Module = Get-ChildItem "$Here\$Sut"
#>

$ParentDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$Module = Split-Path -Leaf $ParentDirectory

Describe "Module: $Module" -Tag Unit {

    Context "Module Configuration" {

        It "Has a root module file ($Module.psm1)" {

            "$ParentDirectory\$Module.psm1" | Should Exist

        }

        It "Has a module manifest ($Module.psd1)" {

            "$ParentDirectory\$Module.psd1" | Should Exist

        }

        It "Contains a root module path in the manifest (ROotModule = '.\$Module.psm1')" {

            "$ParentDirectory\$Module.psd1" | Should Contain "\.\\$Module.psm1"

        }

    }

    #This is the first test you should run in most cases, this will check that there are no errors in the script syntax.
    Context "Build Test" {

        It "is valid Powershell (Has no script errors)" {

            $Contents = Get-Content -Path "$ParentDirectory\$Module.psm1" -ErrorAction Stop
            $Errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
            $Errors | Should -HaveCount 0

        }

    }

    #Always create different tests that use different inputs and permutations. This makes the tested code more reliable, especially in the future when changes are made or new features are added.
    Context "Basic Features" {

        #Start by dot-sourcing to import the function stored in the script you're testing. Can also import other functions for creating a test enviornment.
        . $File

        #May want to create some test files in the test drive depending on the function and its utility:
        Set-Content TestDrive:\test.txt -Value "New File"
        Set-Content TestDrive:\test2.txt -Value "New File 2"

        It "Creates a shortcut" {

            #Call the function and fill in the required parameters with test values.
            New-Shortcut -Source "TestDrive:\test.txt" -Destination $TestDrive -Name "Test"
            "TestDrive:\Test2.lnk" | Should Exist

        }

        It "Outputs a  file" {

            $Result = New-Shortcut -Source "TestDrive:\test.txt" -Destination $TestDrive -Name "Test"
            $Result | Should Not BeNullOrEmpty
            $Result[0] | Should Exist
            $Result.GetType().Name | Should Be FileInfo

        }

        It "Creates multiple shortcuts with names" {

            $Files = Get-ChildItem TestDrive:\test*.txt
            $Result = New-Shortcut -Source $Files -Destination $TestDrive -Name "Test"
            $Result | Should Not BeNullOrEmpty
            $Result[0] | Should Exist
            $Result.Count | Should Be 4

        }


    }



}