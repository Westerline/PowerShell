<#
Step 1: Create CSV with Usernames, Telephone, Mobilephone, and Homephone numbers
    Param (
    [String] $Filter = '*'
    )
    Get-ADUser -Filter $Filter -Property Name, TelephoneNumber, MobilePhone, HomePhone, OfficePhone | Export-Csv C:\Temp\ADUsers_BAK.csv -Force
Step 2: Import that CSV
Step 3: Update AD users with information from imported CSV
#>

Param (
    [String] $Path
)

Begin {
    $CSV = Import-CSV -Path $Path
}

Process {
    Foreach ($User in $CSV) {
        Try {
            $ADUser = Set-ADUser -DisplayName $User.DisplayName -MobilePhone $User.MobilePhone -HomePhone $User.HomePhone -OfficePhone $User.OfficePhone
            $Property = @{
                Status      = 'Successful'
                User        = $ADUser.DisplayName
                MobilePhone = $ADUser.MobilePhone
                HomePhone   = $ADUser.HomePhone
                OfficePhone = $ADUser.OfficePhone
            }
        }

        Catch { 
            $Property = @{
                Status      = 'Unsuccessful'
                User        = $ADUser.DisplayName
                MobilePhone = $ADUser.MobilePhone
                HomePhone   = $ADUser.HomePhone
                OfficePhone = $ADUser.OfficePhone
            }
        }

        Finally {
            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object
        }
    }
}

End { }