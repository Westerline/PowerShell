<#
Requires GroupPolicy Module
#>
$ComputerName =

Foreach ($Computer in $ComputerName) {

    Add-ADGroupMember -Identity $Identity -Members "CN=$Computer,OU=Computers,OU=Computers,OU=MyBusiness,DC=domain,DC=local"

}
