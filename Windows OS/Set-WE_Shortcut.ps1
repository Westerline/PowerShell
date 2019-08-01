<#
#>

Function Set-WE_Shortcut {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('Test')]
        [string]
        $Target,

        [Parameter(Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('Test')]
        [string]
        $Argument,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('Test')]
        [string]
        $Path,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias('Test')]
        [String]
        $FileName

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($P in $Path) {

            Try {

                $Shell = New-Object -ComObject WScript.Shell
                $Shortcut = $Shell.CreateShortcut($P + '\' + $FileName + '.lnk')
                $Shortcut.TargetPath = $Target
                $Shortcut.Arguments = $Argument
                $Shortcut.Save()
                $Property = @{
                    FullName   = $Shortcut.FullName
                    TargetPath = $Shortcut.TargetPath
                    Arguments  = $Shortcut.Arguments
                }

            }

            Catch {

                Write-Verbose "Unable to create shortcut for $FileName."
                $Property = @{
                    FullName   = 'Null'
                    TargetPath = 'Null'
                    Arguments  = 'Null'
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