#Function to get the logical disks attached to LocalHost. Rewrite using WMI and CIM. Refer to PowerShell in a Month of Lunches for a sample script.

wmic.exe logicaldisk get caption, drivetype, volumename, description, mediatype >> <Path>