Function Restore-W10RightClick {
    <#
    .SYNOPSIS
        Restores the classic right-click context menu in Windows 11.

    .DESCRIPTION
        This function restores the classic right-click context menu in Windows 1 by creating a new registry key if it does not already exist.

    .PARAMETER None
        No parameters are required for this function. Use the Restore-DefaultRightClick function to undo the changes. 
    
    
    #>
    $keyLocation = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    try {
        if (!(Test-Path -Path $KeyLocation)) {
            Write-Output "Creating key to restore classic right click context"
            New-Item -Path $KeyLocation -Value "" -Force
            Return 0
        } else {
            Write-Output "Key already exists, skipping creation"
            Return 0
        }
    }
    catch {
        Write-Output "An error occurred: $_"
        Return 1
    }
}

Restore-W10RightClick
Stop-Process -Name explorer -Force
Start-Process explorer