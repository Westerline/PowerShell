#Will result in a successful test. The variable holds the expected value.

Describe "Generic Test" {

    $Actual = "Actual Value"

    It "Test Value" {

        $Actual | Should Be "Actual Value"

    }

    It "Test Value" {

        $Actual | Should Not Be "Actual Value 3"

    }

}