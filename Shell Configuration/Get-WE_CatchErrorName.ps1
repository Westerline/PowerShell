#Generate the desired error - that'll be the egg... then use this little statement to get the exception type - the chicken. You can use the full error name in Catch statements.

Get-Service -Name Service1

Get-AudioDevice
$error[0].exception.gettype().fullname