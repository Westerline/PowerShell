<#
To do: (1) separate gpresult command (2) take before/after snapshots of GPO and see what changed (3) Individual targets
#>

[Cmdletbinding()]

Param ( )

Begin { }

Process {

    Try {


        $Result = & gpresult.exe /R

        $TrimmedResult = $Result | Where-Object { $_.trim() -ne "" }

    }

    Catch { }

    Finally { 
            
        Write-Output $TrimmedResult

    }
    
}

End { }