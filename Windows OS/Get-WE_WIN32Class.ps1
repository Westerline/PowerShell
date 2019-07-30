<#
To do: format output of property and method arrays to be more readable
#>

[Cmdletbinding()]

Param ()

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

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

End {

    $ErrorActionPreference = $StartErrorActionPreference 

}