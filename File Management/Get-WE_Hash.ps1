<#
To do:
#>

Function Get-WE_Hash {

    [cmdletbinding()]

    Param(

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [validatenotnullorempty()]
        [String []]
        $InputFile,

        [Parameter(Mandatory = $False)]
        [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160', 'All')]
        [String]
        $Algorithm = 'All'

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($File in $InputFile) {

            Try {

                $Property = [Ordered]@{
                    File = $File
                }

                If ($Algorithm -eq 'All') {

                    $Algorithm = 'SHA1', 'SHA256', 'SHA384', 'SHA512', 'MACTripleDES', 'MD5', 'RIPEMD160'

                }

                Foreach ($Alg in $Algorithm) {

                    $Hash = Get-FileHash -Path $File -Algorithm $Alg -ErrorAction Stop
                    $Property += @{
                        $Alg = $Hash.Hash
                    }

                }

            }

            Catch [System.Management.Automation.ItemNotFoundException] {

                Write-Verbose "Cannot find path $File."
                $Property += @{
                    $Alg = 'Null'
                }

            }

            Catch {

                Write-Verbose "Could not get the hash on $File. Please ensure the path to the file is correct and try again."
                $Property += @{
                    'Null' = 'Null'
                }

            }

            Finally {

                $Object = New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}