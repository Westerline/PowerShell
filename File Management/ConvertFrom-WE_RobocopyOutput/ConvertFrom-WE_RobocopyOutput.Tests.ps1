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

        It "explicitly writes the object to output" {

            "$Here\$Module.psm1" | Should -FileContentMatch "Write-Output $($Object)"

        }

    }

    Context "Basic features $Module" {

        BeforeAll {

            $InputObject = "
-------------------------------------------------------------------------------
   ROBOCOPY     ::     Robust File Copy for Windows
-------------------------------------------------------------------------------

  Started : Wednesday, 2 October 2019 9:58:18 AM
   Source : C:\temp2\
     Dest : C:\temp3\

    Files : *.*

  Options : *.* /DCOPY:DA /COPY:DAT /R:1000000 /W:30

------------------------------------------------------------------------------

	                   3	C:\temp2\
	  *EXTRA File 		       0	test.txt

------------------------------------------------------------------------------

               Total    Copied   Skipped  Mismatch    FAILED    Extras
    Dirs :         1         0         1         0         0         0
   Files :         3         0         3         0         0         1
   Bytes :    18.6 k         0    18.6 k         0         0         0
   Times :   0:00:00   0:00:00                       0:00:00   0:00:00
   Ended : Wednesday, 2 October 2019 9:58:18 AM
"

        }

        It "Can convert robocopy output from a file." {

            $Result = ConvertFrom-WE_RobocopyOutput -InputObject $InputObject
            $Result | Should -Not -BeNull
            $Result.Status | Should -Be 'Connected'
            #$Result.Started | Should -Be 'Wednesday, 2 October 2019 9:58:18 AM'
            $Result.Source | Should -Be 'C:\temp2\'
            $Result.Destination | Should -Be 'C:\temp3\'
            #$Result.Columns | Should -Be 'Total    Copied   Skipped  Mismatch    FAILED    Extras'
            #$Result.Dirs | Should -Be '1         0         1         0         0         0'
            #$Result.Files | Should -Be '3         0         3         0         0         1'
            #$Result.Ended | Should -Be 'Wednesday, 2 October 2019 9:58:18 AM'

        }

    }

}
