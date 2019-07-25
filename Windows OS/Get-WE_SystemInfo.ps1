<#
#>

[CmdletBinding()]

param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        HelpMessage = "The. Computer. Name.")]
    [Alias('HostName', 'CN')]
    [String[]]$ComputerName

)

Begin { }

Process {

    ForEach ($Computer in $ComputerName) {

        Try {

            $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
            $OS = Get-CimInstance -CimSession $Session -ClassName Win32_OperatingSystem
            $CS = Get-CimInstance -CimSession $Session -ClassName Win32_ComputerSystem
        
            $Property = @{Computername = $ComputerName
                Stauts                 = 'Connected'
                SPVersion              = $OS.ServicePackMajorVersion
                OSVersion              = $OS.Version
                Model                  = $CS.Model

            }
        
        }

        Catch {
            
            Write-Verbose "Unable to establish CIM instance to $Computer"

            $Property = @{Computername = $ComputerName
                Status                 = 'Disconnected'
                SPVersion              = 'Null'
                OSVersion              = 'Null'
                Model                  = 'Null'
            }

        }

        Finally {
            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object
        }

    }
    
}

End { }