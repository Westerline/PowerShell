Get-ChildItem -Recurse <Path>| Measure-Object -Sum Length | Select-Object `

	@{Name="Path"; Expression={$Computer}},

	@{Name="Name"; Expression={$_.FullName}},

	@{Name="Size"; Expression={$_.Sum / 1MB -as [int]}} | Out-File -FilePath C:\Temp\test.txt -Append -Force