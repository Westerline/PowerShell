﻿#Change 1
New-VM -AsJob -BootDevice VHD -ComputerName . -Generation 1 -MemoryStartupBytes 1046MB -Name "VM 1" -SwitchName "External Switch" -VHDPath 'D:\temp\VM_1.vhdx'