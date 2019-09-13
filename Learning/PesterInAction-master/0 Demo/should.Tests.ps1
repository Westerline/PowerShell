# Start https://github.com/pester/Pester/wiki/Should
Describe "Should operations" {

    #A variable should be a value.
    It "Should Be" {
        $actual = "Actual value"
        $actual | Should -Be "Actual value" # Test will pass
        $actual | Should -Not -Be "Some other value" # Test will pass
        # $actual | Should -Be "not actual value"  # Test will fail
    }

    #Same as should be, but is case-sensitive.
    It "Should BeExactly" {
        $actual = "Actual value"
        $actual | Should -BeExactly "Actual value" # Test will pass
        # $actual | Should -BeExactly "actual value" # Test will fail
    }

    #Same as test-path
    It 'Should Exist' { # same as Test-Path
        'c:\windows' | Should -Exist
    }

    #Used to test if a file's contents match a specific value.
    It 'Should FileContentMatch' {
        Set-Content -Path TestDrive:\file.txt -Value 'I am a file'
        'TestDrive:\file.txt' | Should -FileContentMatch 'I Am' # Test will pass
        'TestDrive:\file.txt' | Should -FileContentMatch '^I.*file$' # Test will pass
        # 'TestDrive:\file.txt' | Should -FileContentMatch 'I Am Not' # Test will fail
    }

    #Same as FileContentMatch, but is case-sensitive
    It 'Should ContainExactly' {
        Set-Content -Path TestDrive:\file.txt -Value 'I am a file.'
        'TestDrive:\file.txt' | Should -FileContentMatchExactly 'I am' # Test will pass
        # 'TestDrive:\file.txt' | Should -FileContentMatchExactly 'I Am' # Test will fail
    }

    #Will match a string or value to a regular expression.
    It 'Should Match' {
        "I am a value" | Should -Match "I Am" # Test will pass
        # "I am a value" | Should -Match "I am a bad person" # Test will fail
    }

    #Same as should match but case-sensitive.
    It 'Should MatchExactly' {
        "I am a value" | Should -MatchExactly "I am" # Test will pass
        # "I am a value" | Should -MatchExactly "I Am" # Test will fail
    }

    #Used to test if a command or function throws errors
    It 'Should Throw' {
        { foo } | Should -Throw # Test will pass
        # { $foo = 1 } | Should -Throw # Test will fail
        # { foo } | Should -Not -Throw # Test will fail
        #Used to test if no error is thrown
        { $foo = 1 } | Should -Not -Throw # Test will pass
        { throw "This is a test" } | Should -Throw "This is a test" # Test will pass
        # { throw "bar" } | Show -Throw "This is a test" # Test will fail
    }

    #Very common should option to use when testing.
    It 'Should BeNullOrEmpty' {
        $null | Should -BeNullOrEmpty # Test will pass
        # $null | Should -Not -BeNullOrEmpty # Test will fail
        @() | Should -BeNullOrEmpty # Test will pass
        "" | Should -BeNullOrEmpty # Test will pass
    }

    It 'More options' {
        $true | Should -BeTrue
        $false | Should -BeFalse
        1..4 | Should -HaveCount 4
        4 | Should -BeLessThan 5
        4 | Should -BeGreaterThan 3
        'Test' | Should -BeOfType 'String'
    }
}