<#
To do: (1) separate gpresult command (2) take before/after snapshots of GPO and see what changed (3) Individual targets
#>

Param (
    
)

Begin { }

Process {

    Foreach ($Computer in $ComputerName) {

        Try {

            If ($Credentials.IsPresent) {

                $Result = & gpresult.exe /S $Computer /U $Username /P $Password 
        
            }

            Else {

                $Result = & gpresult.exe /R

            }

            $TrimmedResult = $Result | Where-Object { $_.trim() -ne "" }

        }

        Catch { }

        Finally { 
            
            Write-Output $TrimmedResult

        }
    
    }

}

End { }