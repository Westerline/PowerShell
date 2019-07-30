[CmdletBinding()]

Param( )

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    $ErrorActionPreference = 'SilentlyContinue'

    Try {
    
        $OSPP = Get-ChildItem 'C:\Program Files\', 'C:\Program Files (x86)\' -File -Recurse -Filter 'OSPP.VBS' -ErrorAction SilentlyContinue
        cscript.exe $OSPP.FullName /dstatus
    
    }

    Catch {

    }

}
    
End {

    $ErrorActionPreference = $StartErrorActionPreference 
    
}