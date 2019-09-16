#Requires -Modules Pester
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$here\$sut"

Describe $file.BaseName -Tags Unit {

    #This is the first test you should run in most cases, this will check that there are no errors in the script syntax.
    It "is valid Powershell (Has no script errors)" {

        $contents = Get-Content -Path $file -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors | Should -HaveCount 0
    }

    Context "Basic Features" {

        It "Creates a file" {

            #These tests are run prior to the script executing to ensure an already existing file won't influence tests.
            "TestDrive:\test.txt" | Should -Not -Exist

            #Load the function to test
            ."$file"

            #Call the function and provide values for its parameters. $testdrive is an option parameter that PowerShell will recognize.
            New-File -Source "TestDrive:\test.txt" -Destination "$testdrive"

            #Tests if the function creates the desired file
            "TestDrive:\test.txt" | Should -Exist

        }

    }

}
S