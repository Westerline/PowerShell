function Set-WE_CustomPrompt {
    $Date = (Get-Date).ToShortDateString()
    $Time = (Get-Date).ToShortTimeString()
    "[$env:COMPUTERNAME] {$date $time}:> "
}