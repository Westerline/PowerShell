[Cmdletbinding()]

Param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()] 
    [Alias('ProcessName', 'Process')]
    [String[]] $Name

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {
    
    Foreach ($N in $Name) {
       
        Try {
       
            $Process = Get-WmiObject -Class Win32_Process -Filter "Name like '%$N%'"

            $Property = @{
                Status = 'Successful'
                Name   = $Process.Name
                Owner  = ($Process.GetOwner()).User
            }
       
        }

        Catch { 
       
            $Property = @{
                Status = 'Unsuccessful'
                Name   = $N
                Owner  = 'Null'
            }
       
        }

        Finally {
       
            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object
       
        }
    
    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference 

}