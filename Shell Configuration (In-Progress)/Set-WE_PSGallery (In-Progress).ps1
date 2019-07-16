<#
Troubleshooting Steps Involved to Install PSModules from the PowerShell Gallery. 
PowerShell 5.0 or later is a prerequisite to use the PowerShellGet module. This module is similar to a package manager on a Linux OS.
If you're behind a proxy, you can configure proxy settings as part of the Register-PSRepository or Install-Module parameters.
#1: Check to see if you have any repositories registered:
#2: If no repositories are registered, try registering the default PSGallery below. This will then prompt you to run the command in step 3.
#3: To register the default repository:
#4: Check if the repository was registered:
#5: Install the modules you'd like from PSGallery:
#6: Proxy Settings:
#>

Param (
    $Name = 'PSGallery',
    $SourceLocation = 'https://www.powershellgallery.com/api/v2/',
    $PublishLocation = 'https://www.powershellgallery.com/api/v2/package/',
    $ScriptSourceLocation = 'https://www.powershellgallery.com/api/v2/items/psscript',
    $ScriptPublishLocation = 'https://www.powershellgallery.com/api/v2/package/',
    $InstallationPolicy = 'Trusted'
)

Register-PSRepository -Name $Name -SourceLocation $SourceLocation
            
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