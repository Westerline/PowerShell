Function Uninstall-WE_Program {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('ProgramName')]
        [String[]] $Name

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($N in $Name) {

            Try {

                $Program = Get-WE_InstalledProgram | Where-Object { $_.DisplayName -eq "$N" }
                $UninstallString = $Program.UninstallString -Replace "msiexec.exe", "" -Replace "/I", "" -Replace "/X", ""
                $UninstallArgument = $UninstallString.Trim()
                $UninstallCommand = Start-Process "msiexec.exe" -arg "/X $UninstallArgument /qb" -Wait
                $Property = @{
                    Status           = 'Successful'
                    UninstallCommand = $UninstallCommand
                }

            }

            Catch {

                Write-Verbose "Unable to uninstall the program $N."
                $Property = @{
                    Status           = 'Unsuccessful'
                    UninstallCommand = 'Null'
                }

            }

            Finally {

                New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}