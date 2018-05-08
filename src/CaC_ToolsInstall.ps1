if (Get-Command -Name choco -ErrorAction SilentlyContinue) {
    choco install chocolateygui -y
    choco install googlechrome -y
    choco install nodejs -y
    choco install git -y
    choco install atom -y
    choco install gitkraken -y
    choco install cmder -y
    & "$($env:ProgramFiles)\nodejs\npm.cmd" install npm -g
}
else {
    Write-Warning -Message 'Chocolatey not installed.'
}