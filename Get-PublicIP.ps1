:: For loop, query remote server for public IP address and set it as a variable.
Try{
for /f %%a in ('powershell Invoke-RestMethod api.ipify.org') do set PublicIP=%%a
echo Public IP: %PublicIP%  

}

Catch {

nslookup myip.opendns.com. resolver1.opendns.com

}
