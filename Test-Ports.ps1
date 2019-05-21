$Computers = Get-Content "\\NNDADFP1\Support Centre\Operations\Master Files\Tokens\BOS\BOS.txt"

Foreach ($Computer in $Computers) {

Test-NetConnection $Computer -CommonTCPPort HTTP | Out-File -FilePath 'C:\temp\PSRemote_BOS.txt' -Append



$PortQry = Set-location '.\Utilities\Sysinternals\PortQryUI'
$OutputFile = '.\Log\NZP-Test_Octgn\'

                    #DNS#
.\PortQry.exe -n 0.0.0.0 -p UDP -e 53 -l "$OutputFile\DNS_1.log"
                    #####



                    #HTTP#
.\PortQry.exe -n hostname.com -p TCP -e 80 -l "$OutputFile\HTTP_1.log"
                    ######



                    #FTP#
.\PortQry.exe -n hostname -p TCP -e 20,21 -l "$OutputFile\FTP_1.log"
                    #####
                    
}
