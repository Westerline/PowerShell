Import-Csv -Path test.txt | Select-Object -Property 
@{Label = 'DesiredPropertyName1' ; Expression = { $_.DesiredObjectProperty1 } },
@{Label = 'DesiredPropertyName2' ; Expression = { $_.DesiredObjectProperty2 } },
@{Label = 'etc.' ; Expression = { $_.etc } }