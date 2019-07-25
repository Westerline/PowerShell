<#
To do: expand function to allow CSV import as input (2) secure string parameter and then convert back to plaintext for CmdKey.
#>

[Cmdletbinding(SupportsShouldProcess)]

Param(

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()] 
    [Alias('ComputerName')]
    [String]
    $HostName,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()] 
    [String] 
    $UserName,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()] 
    [String] 
    $Password,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateSet('Domain', 'SmartCard', 'Generic')] 
    [String]
    $Type

)

Begin { }

Process {

    Try {

        Switch ($Type) {

            Domain { $CmdKey = & CmdKey /Add:$HostName /User:$UserName /Pass:$Password }
            SmartCard { $CmdKey = & CmdKey /Add:$HostName /SmartCard }
            Generic { $CmdKey = & CmdKey /Generic:$HostName /User:$UserName /Pass:$Password }

        }

        $Property = @{
            Status             = $CmdKey
            CredentialHostName = & CmdKey /List | findstr $HostName
        }

    }

    Catch {

        $Property = @{
            Status             = "$CmdKey Null"
            CredentialHostName = & CmdKey /List | findstr $HostName
        }

    }

    Finally {
    
        $Object = New-Object -TypeName PSObject -Property $Property
        Write-Output $Object
    }

}

End { }