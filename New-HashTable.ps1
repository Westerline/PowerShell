#A hash table can be used to create a new object property based on an existing object property, useful for adjusting data to work as input for another commandlet. 
#Key1 value = The new name you want your property to have, this should match the required input of the commandlet you want to pipe into
#Key2 value = The existing object property you want to duplicate under a new name

Import-Csv -Path test.txt | 
Select-Object -Property *,
@{Label='DesiredPropertyName1' ;Expression={$_.DesiredObjectProperty1}},
@{Label='DesiredPropertyName2' ;Expression={$_.DesiredObjectProperty2}},
@{Label='etc.' ;Expression={$_.etc.}}