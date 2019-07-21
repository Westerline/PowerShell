<#
Requirements, WinRM service should be configured to accept requests.
#>
[CmdletBinding()]

Param (

    [String[]] $ComputerName

)

Begin {
    $StartErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

}

Process {

    ForEach ($Computer in $ComputerName) {

        Try {
            $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
            $ComputerSystem = Get-CimInstance -CimSession $Session -ClassName Win32_ComputerSystem
            $Property = @{
                Status   = 'Successful'
                Computer = $Computer
                UserName = $ComputerSystem.UserName
            }

        }

        Catch {

            $Property = @{
                Status   = 'Unsuccessful'
                Computer = $Computer
                UserName = 'Null'
            }

        }

        Finally {
            $Object = New-Object -TypeName psobject -Property $Property
            Write-Output $Object
        }
    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference

}