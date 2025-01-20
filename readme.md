## Give me old Right Click

![Give me old right click](src/imgs/right-click-1.png)

### Restoring the Windows 11 context menu

Love it, hate it, the new context menu in Windows 11 has been polarizing. Use the PowerShell scripts in this repository to restore the pre-W11 right click context menu. 

## Functions

The repo consists of three scripts, each with its own function:

- `Restore-W10RightClick.ps1`
    -   Intended to be run as the user account on which you are making the change. Creates the registry key using `HKCU`, then restarts explorer to enact the change. 
- `Restore-W11RightClick.ps1`
    -   Intended to be run as the user account on which you are making the change. Deletes the registry key using `HKCU`, then restarts explorer to enact the change. 
- `Restore-W10RightClick-Intune.ps1`
    -   Intended to be run as the NT\System authority. Will delete the subkeys for *all* accounts, thus restoring the right click context menu behavior to default for all accounts on the machine. This is meant for use in a deployable Intune package due to the necesseity for 'uninstall' commands to run as the NT system authority.  

There is also a simple .cmd one liner that will apply this change with one click. The functions in each script can be used to switch between the two defaults as needed. 

