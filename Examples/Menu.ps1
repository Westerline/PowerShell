while (($inp = Read-Host -Prompt "Select a command") -ne "Q") {

    switch ($inp) {

        L { PING.EXE 127.0.0.1 }
        A { "File will be displayed" }
        R { "File will be write protected" }
        Q { "End" }
        default { "Invalid entry" }

    }

}