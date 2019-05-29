function prompt {
    $date = (Get-Date).ToShortDateString()
    $time = (Get-Date).ToShortTimeString()
    "[$env:COMPUTERNAME] {$date $time}:> "
}