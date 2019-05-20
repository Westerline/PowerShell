$Folder1Path = ""
$Folder2Path = ""

$Folder1Items = Get-ChildItem -Recurse -Path $Folder1Path
$Folder2Items = Get-ChildItem -Recurse -Path $Folder2Path

Compare-Object -ReferenceObject $Folder1Items -DifferenceObject $Folder2Items

$FileDiffs | foreach {
    $CopyParams = @{
    'Path' = $_.InputObject.FullName
    }
    if ($_.SideIndicator -eq '<=')
    {
    $CopyParams.Destination = $Folder2path
    }
    else
    {
    $CopyParams.Destination = Folder1Path
    }
    Copy-Item @copyParams