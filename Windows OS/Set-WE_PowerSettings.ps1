#Enable High Performance
$p = gwmi -NS root\cimv2\power -Class win32_PowerPlan -Filter "ElementName ='High Performance'"
$p.Activate()

#Configure Power Settings
powercfg.exe -x -monitor-timeout-ac 15
powercfg.exe -x -monitor-timeout-dc 15
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0
Write-Host "Power Settings changed sucessfully"