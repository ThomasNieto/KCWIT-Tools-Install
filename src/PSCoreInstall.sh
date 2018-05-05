#!/bin/sh

PsUri=https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/powershell-6.0.2-osx.10.12-x64.pkg
PsPkg=powershell-6.0.2-osx.10.12-x64.pkg
ScriptUri=https://github.com/tnieto88/KCWIT-Tools-Install/blob/master/src/KCWIT_ToolsInstall.ps1
ScriptName=KCWIT_ToolsInstall.ps1
TMP=/tmp

if [ -x "$(command -v pwsh)" ]; then 
    echo 'PowerShell Core already installed.'
else
    echo 'PowerShell Core not installed. Downloading PowerShell Core.'
    wget $PSUri -P $TMP
    echo 'Installing PowerShell Core. You may be prompted for your password.'
    sudo installer -pkg "${TMP}/${PsPkg}" -target /

    if [ -x "$(command -v pwsh)" ]; then 
        echo 'PowerShell Core installed successfully.'
    else
        echo 'PowerShell Core installation failed.'
    fi
fi

wget $ScriptUri -P $TMP
pwsh -File "${TMP}/${ScriptName}" -Verbose