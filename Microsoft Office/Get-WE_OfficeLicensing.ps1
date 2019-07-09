Param(
    
)

$ErrorActionPreference = 'SilentlyContinue'

Try {
    
    $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS'
    cscript.exe $OSPP.FullName /dstatus
    
}

Catch {

}

