# Kansas City Women in Technology Tools Install

Tools Install is a cross-platform (Windows and MacOS) software installation script to assist Coding & Cocktails attendees install their software automatically. Package managers are used to install applications, [Chocolatey](https://chocolatey.org) for Windows and [Homebrew](https://brew.sh/)/[Homebrew Cask](https://caskroom.github.io/) for MacOS.

## Software Installed

### All

* [Google Chrome](https://www.google.com/chrome/)
* [Node.Js](https://nodejs.org/en/)
* [Git](https://git-scm.com/)
* [Atom](https://atom.io/)
* [GitKraken](https://www.gitkraken.com/)

### Windows

* [Chocolatey GUI](https://chocolatey.org/packages/ChocolateyGUI)
* [Cmder](http://cmder.net/)

### MacOS

* [Cakebrew](https://www.cakebrew.com/)

## Installation Steps

### Windows

1. Press <kbd>Windows logo key</kbd>+<kbd>R</kbd> on your keyboard.
    1. Type `powershell.exe`
    2. Press <kbd>Enter</kbd>

1. Copy and Paste the following command in `PowerShell` and press <kbd>Enter</kbd>:
    
    Note: After pasting the command below, a User Account Control window may appear with a message: `Do you want to run this application to make changes to your device?` Click <kbd>Yes</kbd>
    
    ```powershell
   Start-Process -FilePath powershell.exe -Verb RunAs
    ```
    
    1. A new `PowerShell` window will open. Navigate to the `PowerShell` window with the title bar `Adminstrator: Windows PowerShell`.

    1. You may close original `PowerShell` window as it is no longer needed.

1. Copy and Paste the following commands in `PowerShell` and press <kbd>Enter</kdbd>:

    ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
   
   Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

   Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/tnieto88/KCWIT-Tools-Install/rapid-development/src/CaC_ToolsInstall.ps1'))
    ```

1. The script will download and install the various required applications. It may take some time to complete. Please be patient.

1. If there are any errors or warnings please get a hold of a mentor for help.

1. To view, update, install, reinstall, or uninstall packages start `Chocolatey GUI` from the `Start` menu.

### MacOS

1. In Spotlight search for `Terminal` and start the application.

1. Copy and Paste the following commands in `Terminal` and press <kbd>Enter</kbd>:
    
    ```shell
    curl -fsSL https://raw.githubusercontent.com/tnieto88/KCWIT-Tools-Install/rapid-development/src/CaC_ToolsInstall.sh | sh
    ```

1. If you are prompted for your password please type it and press <kbd>Enter</kbd> to continue.

1. If there are any errors or warnings please get a hold of a mentor for help.

1. To view, update, install, reinstall, or uninstall packages start `Cakebrew` from `Applications`.
