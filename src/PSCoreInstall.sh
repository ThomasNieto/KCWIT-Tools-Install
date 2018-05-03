#!/bin/sh

PsUri=https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/powershell-6.0.2-osx.10.12-x64.pkg
PsPkg=powershell-6.0.2-osx.10.12-x64.pkg
TMP=/tmp

wget $PSUri -P "$TMP"
sudo installer -pkg "${TMP}/${PsPkg}" -target /

if [ -x "$(command -v pwsh)" ]; then 
    echo 'PowerShell Core installed successfully.'
else
    echo 'PowerShell Core installation failed.'
fi

#TODO: Download and run KCWIT_ToolsInstall