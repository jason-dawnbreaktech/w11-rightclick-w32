if ((Get-ItemProperty "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32")."(Default)" -eq "") {
    Write-Output "The classic right-click context menu is already restored."
    Exit 0
} else {
    Exit 1
}