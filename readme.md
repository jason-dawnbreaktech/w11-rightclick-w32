## Give Me Old Right Click

![Give me old right click](src/imgs/right-click-1.png)

### Restoring the Windows 11 context menu

Love it, hate it, the new context menu in Windows 11 has been polarizing. Use the PowerShell scripts in this repository to restore the pre-W11 right click context menu. 

## Functions

The repo consists of two scripts containing functions, and a short detection script:

- `Restore-W10RightClick.ps1`
    -   Will create the following registry key:
        `"HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"`
        With a subkey `(Default)` containing an empty string. This will restore the pre-W11 right click context menu. 
- `Restore-W11RightClick.ps1`
    -   This script will delete the key created by the installation script. 
- `detection.ps1`
    - A custom detection script to detect the HKCU registry key after 'installing' the package. This script is **intended to be used with Microsoft Intune.**


The functions in each script can be used to switch between the two defaults as needed. Load them into your **PowerShell Profile** to have the functions available by default.

## How to package for Intune:

1. Clone this repo. 
2. Use the [IntuneWinAppUtil](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) to package the folder with the following command:
``` cmd
IntuneWinAppUtil.exe -c C:\path\to\w11-rightclick-w32 -s Restore-W10RightClick.ps1 -o .
```
3. Upload the resulting `.intunewin` file to Intune with the following settings:

Install command:

` %SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -ex bypass -file .\Restore-W10RightClick.ps1`

Uninstall command: 

`%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -ex bypass -file .\Restore-W11RightClick.ps1`

Installation Context:

**Run as user**

Detection method: 

Custom Script (use `detection.ps1`)

As this is intended for Windows 11, there is no reason to make the package available for Windows 10. Select Windows 11 21H2 as the minimum operating system.

