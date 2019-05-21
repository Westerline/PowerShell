<#Troubleshooting Steps Involved to Install PSModules from the PowerShell Gallery. 
PowerShell 5.0 or later is a prerequisite to use the PowerShellGet module. This module is similar to a package manager on a Linux OS.
If you're behind a proxy, you can configure proxy settings as part of the Register-PSRepository or Install-Module parameters.
#>


    #1: Check to see if you have any repositories registered:

        Get-PSRepository


    #2: If no repositories are registered, try registering the default PSGallery below. This will then prompt you to run the command in step 3.

        $Repository = @{
        Name = 'PSGallery'
        SourceLocation = 'https://www.powershellgallery.com/api/v2/'
        PublishLocation = 'https://www.powershellgallery.com/api/v2/package/'
        ScriptSourceLocation = 'https://www.powershellgallery.com/api/v2/items/psscript'
        ScriptPublishLocation = 'https://www.powershellgallery.com/api/v2/package/'
        InstallationPolicy = 'Trusted'
        }
        Register-PSRepository @Repository

    #3: To register the default repository:
        
        Register-PSRepository -Default

    #4: Check if the repository was registered:
        
        Get-PSRepository

    #5: Install the modules you'd like from PSGallery:

        Install-Module -Name ModuleName -RequiredVersion 1.5 -Repository PSGallery -Force


    #6: Proxy Settings: