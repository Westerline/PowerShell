<#
To do: format output of property and method arrays to be more readable
#>

Begin { }

Process {

    Try {

        $Win32Classes = Get-CimClass -ClassName '*Win32*'
    
    }

    Catch {

    }

    Finally {

        Write-Output $Win32Classes

    }
    
}

End { }