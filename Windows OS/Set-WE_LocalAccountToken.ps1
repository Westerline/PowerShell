<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Create Registry Value for Remote File Share and PSEXEC
.To Do
    Set to 1 for Disable (no remote admin share allowed), Set to 0 for Enable (remote admin share allowed).
#>

Function Set-WE_LocalAccountToken {

    [CmdletBinding(SupportsShouldProcess)]

    Param ()

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            $LocalAccountTokenFilterPolicy = New-ItemProperty -Name LocalAccountTokenFilterPolicy -Value 1 -PropertyType Dword -Force -ErrorAction Stop
            $Property = @{
                LocalAccountTokenFilterPolicy = $LocalAccountTokenFilterPolicy
            }

        }

        Catch {

            Write-Verbose "Unable to set local account token filter policy on $Env:COMPUTERNAME."
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

}