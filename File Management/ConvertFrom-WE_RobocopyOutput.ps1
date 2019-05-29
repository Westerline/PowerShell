#Function to prase the output from the remote log files.
$Global:Robo_Content = $null
$Global:Properties = $null
$Global:Robo_Formatted = $null

Function Format-RobocopyOutput {

    Param($File, $Robo_Computer, $LogPath)
   
    $Global:Robo_Content = (Get-Content $File) -match '^(?= *?\b(Started|Total|Dirs|Files|Ended)\b)((?!    Files).)*$'
     
    $Global:Properties = [Ordered] @{
        Computer = $Robo_Computer
        Columns  = $Global:Robo_Content[1] -replace '(?m)^\s+'
        Dirs     = $Global:Robo_Content[2] -replace 'Dirs :' -replace '(?m)^\s+'
        Files    = $Global:Robo_Content[3] -replace 'Files :' -replace '(?m)^\s+'
        Started  = $Global:Robo_Content[0] -replace 'Started :' -replace '(?m)^\s+'
        Ended    = $Global:Robo_Content[4] -replace 'Ended :' -replace '(?m)^\s+'
    }
                                
    $Global:Robo_Formatted = New-Object -TypeName psobject -Property $Properties | Out-File -FilePath $LogPath -Append

}