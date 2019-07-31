<#
Comment based help goes at the top.

Tools should do one thing. A controller script is what takes a bunch of tools and gives them context and purpose. Controller scripts should be really simple and have minimal logic. Improved debugging and modularization.

Multiple functions can be combined together into a module. Modules have the .psm1 extension.

Saved as a function so that we can have it be part of a PowerShell module. Best practice for auto-loading modules is to modify PSModule path with an additional location for modules. Do this by appending the environment variables.

Modules can have more than one file, this is where manifest files come in. Loads files in this order: .psd1, .dll, .psm1. To create a manifest, use the following:
    Set-Location -Path <Path to PowerShell Module>
    New-ModuleManifest -Path ModuleName.psd1 -RootModule ModuleName.psm1
Manifest files are the prefered place to put in minimum requirements for the module to load.
Manifest files should contain all of the meta-data for a module.
Manifest files are also the prefered place to create your own custom formatting instructions for your object output.
Manifest files should be used to explicitly state which functions from your module should be exported
#>


Function PowerShellToolmakingVideoSeries {

    #Enables common parameters
    #SupportsShouldProcess enables -whatif and -confirm parameters. You only need this if your commands are changing things.
    [CmdletBinding()]
    param (

        #Allows us to accept parameter input from the pipeline by object type and by property name.
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "The. Computer. Name.")]

        #You can create aliases that will allow you to bind ValueFromPipelineByPropertyName. For example, if you get AD Objects, and it comes back with 'CN' property containing the names of users, 'CN' alias will bind to that input.
        [Alias('HostName', 'CN')]
        #[] used to allow for multi-object input.
        [String[]]$ComputerName

    )

    #Begin, Process, End supports the pipeline input run scenario. The ForEach supports the parameter input run scenario.
    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        #Foreach used, rather than loading the objects and piping each one to the command, because it supports a broader range of input patterns.
        ForEach ($Computer in $ComputerName) {

            #If an error were to occur, $Session is likely place. We want to wrap all the way through to Write-Output in a try because we don't want the rest of the code to execute.
            Try {

                #Instead of setting up two CIM connections, we're setting up one CIM session for OS and CS to use
                $Session = New-CimSession -ComputerName $Computer -ErrorAction Stop
                $OS = Get-CimInstance -CimSession $Session -ClassName Win32_OperatingSystem
                $CS = Get-CimInstance -CimSession $Session -ClassName Win32_ComputerSystem

                <#
            Instead of outputting two different object types, we're going to create a hash table of the properties we want from our two objects.
            Non-ordered hash tables are more memory efficient
            #>
                $Property = @{Computername = $ComputerName
                    Stauts                 = 'Connected'
                    SPVersion              = $OS.ServicePackMajorVersion
                    OSVersion              = $OS.Version
                    Model                  = $CS.Model
                }

            }

            Catch {

                #We will only get verbose output if CmdletBinding is enabled and the -Verbose parameter is used. -Verbose parameter gets passed to all commands.
                #If you want to create a section header, the verbose pipeline is a good place for that
                Write-Verbose '---------------------------------------------'
                Write-Verbose "Unable to establish CIM instance to $Computer"

                #We will still generate an output object, but this can give us more information about the error.
                $Property = @{Computername = $ComputerName
                    Status                 = 'Disconnected'
                    SPVersion              = 'Null'
                    OSVersion              = 'Null'
                    Model                  = 'Null'
                }

            }

            Finally {

                <#Next, we create a PSObject that has either the try or catch properties we retrieved above. This is saved to a variable for a couple reasons
            1. Lets us change $Object before outputting
            2. It's good practice to explicitly write your output, that way you can see where in your code to start investigating if there are output errors.

            Don't use Format commands within your script because this doesn't produce a PSObject.

            #>
                $Object = New-Object -TypeName PSObject -Property $Property
                #It is possible to create a custom format view as part of your module. If you do this, you'll want to convert $Object to a different custom object name. This object name will then correlate to the name in your custom format XML.
                $Object.PSObject.TypeNames.Insert(0, 'My.Awesome.Object')
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}