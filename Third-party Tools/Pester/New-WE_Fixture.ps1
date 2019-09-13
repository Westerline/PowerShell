$Modules = Get-ChildItem 'C:\Github\PowerShell' -Filter *.ps1 -Recurse | Where-Object { ($_.FullName -notlike '*Examples*') -and ($_.FullName -notlike '*Learning*') }

Foreach ($Module in $Modules) {

    Try {

        New-Fixture -Path $Module.DirectoryName -Name $Module.Name

    }

    Catch {


    }

}