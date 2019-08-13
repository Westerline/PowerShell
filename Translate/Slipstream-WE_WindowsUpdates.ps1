::To Slipstream Updates into a WIM file or Windows ISO, use these commands as an outline.

Dism.exe /Mount-WIM /WimFile:C:\Win7SP1x64\sources\install.wim /Name:"Windows 7 Professional" /MountDir:C:\Win7SP1x64\offline

Dism.exe /Image:C:\Win7SP1x64\offline /Add-Package /PackagePath:C:\Updatesx64\Windows6.1-KB3020369-x64.msu

Dism.exe /Unmount-WIM /MountDir:C:\Win7SP1x64\offline /Commit


::Then from the appropriate Windows AIK Toolkit Command Prompt. In this example, Windows 7 is used.

oscdimg -m -u2 -bC:\Win7SP1x64\boot\etfsboot.com C:\Win7SP1x64\ C:\Windows7_Slipstream_x64.iso

Dism.exe /Mount-WIM /WimFile:C:\Win7SP1x86\sources\install.wim /Name:"Windows 7 Professional" /MountDir:C:\Win7SP1x86\offline

Dism.exe /Image:C:\Win7SP1x86\offline /Add-Package /PackagePath:C:\Updatesx86\Windows6.1-KB3020369-x86.msu

Dism.exe /Unmount-WIM /MountDir:C:\Win7SP1x86\offline /Commit

::From the Windows 7 AIK Deployment Tools Command Prompt:

oscdimg -m -u2 -bC:\Win7SP1x86\boot\etfsboot.com C:\Win7SP1x86\ C:\Windows7_Slipstream_x86.iso