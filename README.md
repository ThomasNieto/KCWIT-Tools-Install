# Kansas City Women in Technology Tools Install

Tools Install is a cross-platform (Windows and MacOS) software installation script to assist Coding & Cocktails attendees install their software automatically.

## Software Installed

The following software is installed with the script.

* [PowerShell Core 6](https://github.com/PowerShell/PowerShell)
* [Google Chrome](https://www.google.com/chrome/)
* [Node.Js](https://nodejs.org/en/)
* [Git](https://git-scm.com/)
* [Atom](https://atom.io/)
* [GitKraken](https://www.gitkraken.com/)

## Installation Steps

### Windows

1. Press <kbd>Windows logo key</kbd>+<kbd>R</kbd> on your keyboard.
    1. Type `PowerShell.exe`
    2. Press <kbd>Enter</kbd>

2. Copy and Paste the following commands in `PowerShell` and press <kbd>Enter</kbd>:
    
    Note: After pasting the commands below, a User Account Control window may appear mulitple times with a message saying `Do you want to run this application to make changes to your device?` Click <kbd>Yes</kbd>
    
    ```powershell
    $ToolsUrl = 'https://github.com/tnieto88/KCWIT-Tools-Install/blob/master/src/KCWIT_ToolsInstall.ps1'
    $ScriptPath = "$($Env:TEMP)\KCWIT_ToolsInstall.ps1"
    $WebClient = New-Object -TypeName System.Net.WebClient
    $WebClient.DownloadFile($ToolsUrl, ScriptPath)
    Start-Process -FilePath powershell.exe -ArgumentList "-File $ScriptPath -Verbose" -Verb RunAs
    ```

3. The script will download and install the various required applications. It may take some time to complete. Please be patient.

4. If there are any errors or warnings please get a hold of a mentor for help.

### MacOS

1. In Spotlight search for `Terminal` and start the application.

2. Copy and Paste the following commands in `Terminal` and press <kbd>Enter</kbd>:
    
    ```shell
    ScriptUrl=https://github.com/tnieto88/KCWIT-Tools-Install/blob/master/src/PSCoreInstall.sh
    ScriptName=PSCoreInstall.sh
    TMP=/tmp
    ScriptPath=$TMP/$ScriptName
    wget $ScriptUrl -P $TMP
    chmod +x $ScriptPath
    $ScriptPath
    ```

3. The script will download and install `PowerShell Core` if not already installed then install the various required applications. It may take some time to complete. Please be patient.

4. If there are any errors or warnings please get a hold of a mentor for help.