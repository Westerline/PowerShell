<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Create Registry Value for Remote File Share and PSEXEC
.To Do
    Set to 1 for Disable (no remote admin share allowed), Set to 0 for Enable (remote admin share allowed).
#>

[CmdletBinding(SupportsShouldProcess)]

Param ()

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Try {

        $LocalAccountTokenFilterPolicy = New-ItemProperty -Name LocalAccountTokenFilterPolicy -Value 1 -PropertyType Dword -Force
        $Property = @{
            LocalAccountTokenFilterPolicy = $LocalAccountTokenFilterPolicy 
        }

    }

    Catch {

        $Property = @{
            LocalAccountTokenFilterPolicy = 'Null'
        }

    }

    Finally {

        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object
        
    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference 

}