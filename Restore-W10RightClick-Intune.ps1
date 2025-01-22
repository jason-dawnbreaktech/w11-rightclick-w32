<# Define the key and value you want to create
$keyPath = "Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
$flagKeyPath = "Software\MyApps\InstallFlags"
$flagName = "RightClickContextRestored"
$flagValue = 1

# Get all user hives under HKEY_USERS
$users = Get-ChildItem -Path Registry::HKEY_USERS | Where-Object { $_.Name -notlike '*_Classes' } | Select-Object -ExpandProperty PSPath

foreach ($user in $users) {
    Write-Host "Processing: $user"
    
    # Construct the full registry path for the target key
    $targetKey = "$user\$keyPath"
    $flagKey = "$user\$flagKeyPath"

    try {
        # Check if the key already exists
        if (-not (Test-Path -Path $targetKey)) {
            # Create the key
            New-Item -Path $targetKey -Force | Out-Null
            Write-Output "Created registry key: $targetKey"

            # Add a default value to the key
            Set-ItemProperty -Path $targetKey -Name "(Default)" -Value "" -Force
            Write-Output "Added default value to: $targetKey"
        } else {
            Write-Output "Registry key already exists: $targetKey"
        }

        # Set a flag to mark the installation
        if (-not (Test-Path -Path $flagKey)) {
            New-Item -Path $flagKey -Force | Out-Null
        }
        Set-ItemProperty -Path $flagKey -Name $flagName -Value $flagValue -Force
        Write-Output "Set install flag for user: $user"
        Stop-Process -Name explorer -Force
        Start-Process explorer
    } catch {
        Write-Output "Error processing" $user":" "$_"
    }
}



# Define the key and value to create
$keyPath = "SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
$flagKeyPath = "SOFTWARE\Microsoft\Windows\ContextMenuReverted\Flags"
$flagName = "CurrentState"
$flagValue = 1

# Get all user hives under HKEY_USERS
$users = Get-ChildItem -Path Registry::HKEY_USERS | Where-Object { $_.Name -notlike '*_Classes' } | Select-Object -ExpandProperty PSPath

foreach ($user in $users) {
    Write-Host "Processing: $user"
    
    # Construct the full registry path for the target key
    $targetKey = "$user\$keyPath"
    $flagKey = "$user\$flagKeyPath"

    try {
        # Check if the key already exists
        if (-not (Test-Path -Path $targetKey)) {
            # Create the key
            New-Item -Path $targetKey -Force | Out-Null
            Write-Output "Created registry key: $targetKey"

            # Add a default value to the key
            Set-ItemProperty -Path $targetKey -Name "(Default)" -Value "" -Force
            Write-Output "Added default value to: $targetKey"
        } else {
            Write-Output "Registry key already exists: $targetKey"
        }

        # Set a flag to mark the installation
        if (-not (Test-Path -Path $flagKey)) {
            New-Item -Path $flagKey -Force | Out-Null
        }
        Set-ItemProperty -Path $flagKey -Name $flagName -Value $flagValue -Force
        Write-Output "Set install flag for user: $user"
    } catch {
        Write-Output "Error processing $user: $_"
    }
}

# Apply the changes to the current session
Write-Output "Restarting Explorer to apply changes..."
Stop-Process -Name explorer -Force
Start-Process explorer
#>

# Define paths and keys
# Define paths and keys
$hklmBaseKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\ContextMenuReverted"
$hklmSubKeyPath = "Flags"
$hklmFlagName = "CurrentState"
$hklmFlagValue = 1
$userKeyPath = "Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

# Ensure the HKLM main key and subkey exist
if (-not (Test-Path $hklmBaseKeyPath)) {
    New-Item -Path $hklmBaseKeyPath -Force | Out-Null
    Write-Output "Created registry key: $hklmBaseKeyPath"
}
if (-not (Test-Path "$hklmBaseKeyPath\$hklmSubKeyPath")) {
    New-Item -Path "$hklmBaseKeyPath\$hklmSubKeyPath" -Force | Out-Null
    Write-Output "Created subkey: $hklmBaseKeyPath\$hklmSubKeyPath"
}

# Set the HKLM flag to indicate the restored state
Set-ItemProperty -Path "$hklmBaseKeyPath\$hklmSubKeyPath" -Name $hklmFlagName -Value $hklmFlagValue -Force
Write-Output "Set HKLM flag '$hklmFlagName' to: $hklmFlagValue in $hklmBaseKeyPath\$hklmSubKeyPath, marking the restored state."

# Iterate through all user hives and create the HKCU keys
Get-ChildItem -Path Registry::HKEY_USERS | Where-Object { $_.Name -notlike '*_Classes' } | ForEach-Object {
    $targetKey = "$($_.PSPath)\$userKeyPath"
    try {
        # Create the user-specific registry key if it doesn't exist
        if (-not (Test-Path -Path $targetKey)) {
            New-Item -Path $targetKey -Force | Out-Null
            Write-Output "Created registry key: $targetKey"

            # Add a default value to the key
            Set-ItemProperty -Path $targetKey -Name "(Default)" -Value "" -Force
            Write-Output "Added default value of a blank string to: $targetKey"
        } else {
            Write-Output "Registry key already exists: $targetKey"
        }
    } catch {
        Write-Output "Error processing $targetKey ":" $_"
    }
}

# Restart Explorer to apply the changes
Write-Output "Restarting Explorer to apply changes..."
Stop-Process -Name explorer -Force
Start-Process explorer
