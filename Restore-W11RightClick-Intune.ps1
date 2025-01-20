# Iterate through all the user hives and restore the right-click context menu.

$users = Get-ChildItem -Path Registry::HKEY_USERS | Select-Object -ExpandProperty PSPath

foreach ($user in $users) {
    Write-Host $user
    if (Test-Path "$user\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32") {
        Remove-Item -Path "$user\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force
        Write-Output "Key removed successfully."
    }
}

