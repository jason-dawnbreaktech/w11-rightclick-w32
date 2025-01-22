
# Define paths and keys
$userKeyPath = "Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

# Iterate through all user hives and remove HKCU keys
Get-ChildItem -Path Registry::HKEY_USERS | Where-Object { $_.Name -notlike '*_Classes' } | ForEach-Object {
    $targetKey = "$($_.PSPath)\$userKeyPath"
    if (Test-Path $targetKey) {
        Remove-Item -Path $targetKey -Recurse -Force
        Write-Output "Removed user key: $targetKey"
    }
}

# Define the base path and keys
$baseKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\ContextMenuReverted"
$subKeyPath = "Flags"
$flagName = "CurrentState"

# Ensure the main key exists
if (-not (Test-Path $baseKeyPath)) {
    New-Item -Path $baseKeyPath -Force | Out-Null
    Write-Output "Created registry key: $baseKeyPath"
}

# Ensure the subkey exists
if (-not (Test-Path "$baseKeyPath\$subKeyPath")) {
    New-Item -Path "$baseKeyPath\$subKeyPath" -Force | Out-Null
    Write-Output "Created subkey: $baseKeyPath\$subKeyPath"
}

# Toggle the flag value between 0 (off) and 1 (on)
$currentValue = (Get-ItemProperty -Path "$baseKeyPath\$subKeyPath" -Name $flagName -ErrorAction SilentlyContinue).$flagName
$newValue = if ($currentValue -eq 1) { 0 } else { 1 }
Set-ItemProperty -Path "$baseKeyPath\$subKeyPath" -Name $flagName -Value $newValue -Force
Write-Output "Flag '$flagName' set to: $newValue in $baseKeyPath\$subKeyPath"

