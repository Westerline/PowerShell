<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Troubleshooting Steps Involved to Install PSModules from the PowerShell Gallery. 
    PowerShell 5.0 or later is a prerequisite to use the PowerShellGet module. This module is similar to a package manager on a Linux OS.
    If you're behind a proxy, you can configure proxy settings as part of the Register-PSRepository or Install-Module parameters.
    #1: Check to see if you have any repositories registered:
    #2: If no repositories are registered, try registering the default PSGallery below. This will then prompt you to run the command in step 3.
    #3: To register the default repository:
    #4: Check if the repository was registered:
    #5: Install the modules you'd like from PSGallery:
    #6: Proxy Settings:

.PARAMETER UseExitCode
    This is a detailed description of the parameters.

.EXAMPLE
    Scriptname.ps1

    Description
    ----------
    This would be the description for the example.

.NOTES
    Author: Wesley Esterline
    Resources: 
    Updated:     
    Modified from Template Found on Spiceworks: https://community.spiceworks.com/scripts/show/3647-powershell-script-template?utm_source=copy_paste&utm_campaign=growth
#>

[CmdletBinding()]

Param (

    [Parameter(Mandatory = $False)]
    [Alias('Transcript')]
    [string]$TranscriptFile

)

Begin {
    Start-Transcript $TranscriptFile  -Append -Force
    $StartErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

}

Process {

    Try {      
       
        Get-PSRepository

        $Repository = @{
            Name                  = 'PSGallery'
            SourceLocation        = 'https://www.powershellgallery.com/api/v2/'
            PublishLocation       = 'https://www.powershellgallery.com/api/v2/package/'
            ScriptSourceLocation  = 'https://www.powershellgallery.com/api/v2/items/psscript'
            ScriptPublishLocation = 'https://www.powershellgallery.com/api/v2/package/'
            InstallationPolicy    = 'Trusted'
        }
        Register-PSRepository @Repository
            
        Register-PSRepository -Default
                
        Get-PSRepository
        
        Install-Module -Name ModuleName -RequiredVersion 1.5 -Repository PSGallery -Force
        
    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference
    Stop-Transcript | Out-Null
}