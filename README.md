# Kansas City Women in Technology Tools Install

Tools Install is a cross-platform (Windows and MacOS) software installation script to assist Coding & Cocktails attendees install their software automatically.

## Software Installed

The following software is installed with the script.

* [PowerShell Core 6](https://github.com/PowerShell/PowerShell)
* [Chrome](https://www.google.com/chrome/)
* [NodeJs](https://nodejs.org/en/)
* [Git](https://git-scm.com/)
* [Atom](https://atom.io/)
* [GitKraken](https://www.gitkraken.com/)

## Installation Steps

### Windows

1. Download KCWIT_ToolsInstall.ps1 script to your user's download folder.
2. Press <kbd>Windows logo key</kbd>+<kbd>R</kbd> on your keyboard.
    1. Type `PowerShell.exe`
    2. Press Enter
3. Copy and Paste the following commands in PowerShell and press <kbd>Enter</kbd>:
    
    Note: After pasting the commands below, a User Account Control window may appear with a message saying `Do you want to run this application to make changes to your device?` Click <kbd>Yes</kbd>
    ```powershell
    $ScriptPath = Get-ChildItem -Path $env:USERPROFILE -Filter KCWIT_ToolsInstall.ps1 -Recurse
    Start-Process -FilePath powershell.exe -ArgumentList $ScriptPath -Verb RunAs
    ```
4. The script will download and install the various required applications. It may take some time to complete. Please be patient.
5. If there are any errors or warnings please get a hold of a mentor for help.
