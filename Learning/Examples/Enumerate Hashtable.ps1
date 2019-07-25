#Used to iterate both the key and value of each object in a hash table.
$HashTable.GetEnumerator() | ForEach-Object {

    $message = 'Querying {0} @ {1}...' -f $_.key, $_.value

    Write-Output $message

    $IP = $_.value

    Get-ChildItem \\$IP\c$

}