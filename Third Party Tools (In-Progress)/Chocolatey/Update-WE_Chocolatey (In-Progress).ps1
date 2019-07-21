[CmdletBinding()]
Param (
    [String[]] $Software
)

Process {

    Try {
        
        Foreach ($Soft in $Software) {

            Choco Upgrade $Soft -y

        }
    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}