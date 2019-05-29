#Turn this into a parameterized script for transferring files

$Group1 = @("Test1a", "Test1b")
$Group2 = @("Test2a", "Test2b")

$Source = ""

$Destination = ""

ForEach ($Test in $Group1) {

    robocopy $Source ($Test + $Destination) /MT /NP /R:1 /w:5 /E  >> "C:\temp\$Test.txt"
   
}

ForEach ($Test in $Group2) {

    robocopy $Source ($Test + $Destination) /MT /NP /R:1 /w:5 /E  >> "C:\temp\$Test.txt"

}