<#
Switch Parameter Type vs Boolean Parameter Type
https://blogs.technet.microsoft.com/bulentozkir/2017/06/20/the-difference-between-switch-andbool-in-powershell-function-parameters/
#>

#Switch Parameter

function MyAwesomeFunction1 {
    [CMDLetBinding()]
    param
    (
        [string] $foo,
        [string] $bar,
        [switch] $someVariable
        
    )

    Write-Host "someVariable = $someVariable" + $someVariable.GetType()

    if ($someVariable) {
        Write-Host $foo
    }
    else {
        Write-Host $bar
    }
}

#Boolean Parameter
function MyAwesomeFunction2 {
    [CMDLetBinding()]
    param
    (
        [string] $foo,
        [string] $bar,
        [bool] $someVariable
    )

    Write-Host "someVariable = $someVariable" + $someVariable.GetType()

    if ($someVariable) {
        Write-Host $foo
    }
    else {
        Write-Host $bar
    }
}

MyAwesomeFunction1 -foo "foo" -bar "bar" -someVariable:$true
MyAwesomeFunction1 -foo "foo" -bar "bar" -someVariable:$false
MyAwesomeFunction1 -foo "foo" -bar "bar" -someVariable
MyAwesomeFunction1 -foo "foo" -bar "bar"

MyAwesomeFunction2 -foo "foo" -bar "bar" -someVariable $true
MyAwesomeFunction2 -foo "foo" -bar "bar" -someVariable $false
MyAwesomeFunction2 -foo "foo" -bar "bar" -someVariable
MyAwesomeFunction2 -foo "foo" -bar "bar"