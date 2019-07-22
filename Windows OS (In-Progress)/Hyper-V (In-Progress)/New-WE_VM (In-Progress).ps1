<#
To do: configure input for multiple VMs
#>
New-VM -BootDevice VHD -ComputerName . -Generation 1 -MemoryStartupBytes 1046MB -Name "VM 1" -SwitchName "External Switch" -VHDPath 'D:\temp\VM_1.vhdx'