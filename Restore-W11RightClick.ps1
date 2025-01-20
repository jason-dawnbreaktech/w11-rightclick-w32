function Restore-Win11RightClick {
    <#
    .SYNOPSIS
        Restores the classic right-click context menu in Windows 11.

    .DESCRIPTION
        This function restores the default right-click context menu in Windows 11 by deleting the existing key and restoring the default context menu.
    #>
    $keyLocation = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    try {
        if (Test-Path -Path $keyLocation) {
            Remove-Item -Path $keyLocation -Force
            Write-Output "Key removed successfully."
        } else {
            Write-Output "You are already using the default right-click menu."
        }
    } catch {
        Write-Output "An error occurred: $_"
    }
}



