.'C:\test\hashtable.ps1'

Get-ChildItem 'C:\test\folders' -Folders | ForEach-Object -Process {

    $Number = $_.Name

    $Name = $HashTable_Names.[int]$Number

    Rename-Item -Path $_.FullName -NewName $Name

}