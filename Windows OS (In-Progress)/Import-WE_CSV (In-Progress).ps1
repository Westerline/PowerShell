<#
.SYNOPSIS
    This is a very short summary of the script.

.DESCRIPTION
    Section 1: Creates a new object in the excel application, opens the workbook, and then opens the worksheet  
    Checks the number of rows that have values
    Declares starting position for each column
    The next step is to loop through each row and store each variable that you can use for anything you want
    Finally, converts secure password to Plain Text

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


Try {

    #Section 1
    $File = "C:\test.txt"
    $SheetName = 'test1'
    $ObjExcel = New-Object -ComObject Excel.Application
    $Workbook = $ObjExcel.Workbooks.Open($File)
    $Sheet = $Workbook.Worksheets.Item($SheetName)
    $ObjExcel.Visible = $false
    $Rowmax = ($Sheet.UsedRange.Rows).count

    #Section 2
    $Row1, $ColBranch = 1, 1
    $RowName, $ColName = 1, 2
    $RowStaticIP, $ColStaticIP = 1, 3
    $RowUserName, $ColUsername = 1, 4
    $RowPassword, $ColPassword = 1, 5

    for ($i = 1; $i -le $rowMax - 1; $i++) {
        $Name = $sheet.Cells.Item($rowName + $i, $colName).text
        $Age = $sheet.Cells.Item($rowAge + $i, $colAge).text
        $City = $sheet.Cells.Item($rowCity + $i, $colCity).text

    }

    [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential)
    }

    Catch [SpecificException] {
        
    }

    Catch {


    }

    Finally {

    }