<#
Resources: https://techibee.com/powershell/convert-from-any-to-any-bytes-kb-mb-gb-tb-using-powershell/2376
#>

Function Convert-WE_Bytes {            
    [cmdletbinding()]            
    param(            
        [validateset('B', 'KB', 'MB', 'GB', 'TB')]            
        [string]$From,            
        [validateset('B', 'KB', 'MB', 'GB', 'TB')]            
        [string]$To,            
        [Parameter(Mandatory = $true)]            
        [Double]$Value,            
        [int]$Precision = 4            
    )       
         
    Switch ($From) {            
        'B' { $Value = $Value }            
        'KB' { $value = $Value * 1000 }            
        'MB' { $value = $Value * 1000000 }            
        'GB' { $value = $Value * 1000000000 }            
        'TB' { $value = $Value * 1000000000000 }            
    }            
            
    Switch ($To) {            
        'B' { $Value = $Value }            
        'KB' { $Value = $Value / 1000 }            
        'MB' { $Value = $Value / 1000000 }            
        'GB' { $Value = $Value / 1000000000 }            
        'TB' { $Value = $Value / 1000000000000 }            
            
    }            
            
    $Math = [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)   
    Write-Output $Math$To      
            
}           