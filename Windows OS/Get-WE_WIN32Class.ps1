<#
To do: format output of property and method arrays to be more readable
#>

Function Get-WE_Win32Class {

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

            Write-Verbose "Unable to fetch Win32 classes on $Env:COMPUTERNAME."
            $Win32Classes = "Unable to fetch Win32 classes on $Env:COMPUTERNAME."

        }

        Finally {

            Write-Output $Win32Classes

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}