#Requires -Modules Pester
# Can easily be created with "New-Fixture" command.
# Here stores the path where the script is running from
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# Sut replaces .tests with just . in the file name string
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$file = Get-ChildItem "$here\$sut"

Describe "Create desktop shortcut script" {

    #This test can be used to ensure the script doesn't have any PowerShell syntax errors. Similar to a compile/build test.
    It "is valid Powershell (Has no script errors)" {

        $contents = Get-Content -Path $file -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors | Should -HaveCount 0
    }

    It "Creates a shortcut on the desktop" {

        #Start by invoking the file by name which runs the script.
        & $file.FullName

        #Define the location of the shortcut
        $path = "$env:USERPROFILE\Downloads\Notepad.lnk"
        $path | Should -Exist
    }
}
