<#
Requirements, WinRM service should be configured to accept requests.
#>

[CmdletBinding(SupportsShouldProcess)]

Param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Alias('HostName')]
    [String[]]
    $ComputerName

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

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

            Write-Verbose "Unable to get the currently logged in user for $Computer. Please ensure the computer is available on the network."
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