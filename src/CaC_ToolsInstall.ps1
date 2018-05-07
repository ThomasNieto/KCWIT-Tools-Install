if (Get-Command -Name choco -ErrorAction SilentlyContinue) {
    $InstalledPackages = choco list --local-only
    
    if ($InstalledPackages -like '*chocolateygui*') {
        Write-Host 'Chocolatey GUI already installed.'
    }
    else {
        Write-Host 'Installing Chocolatey GUI.'
        choco install chocolateygui -y
    }
    
    if ($InstalledPackages -like '*GoogleChrome*') {
        Write-Host 'Google Chrome already installed.'
    }
    else {
        Write-Host 'Installing Google Chrome.'
        choco install googlechrome -y
    }
    
    if ($InstalledPackages -like '*nodejs*') {
        Write-Host 'Node.Js already installed.'
    }
    else {
        Write-Host 'Installing Node.Js.'
        choco install nodejs -y
    }
    
    if ($InstalledPackages -like '*git*') {
        Write-Host 'Git already installed.'
    }
    else {
        Write-Host 'Installing Git.'
        choco install git -y
    }
    
    if ($InstalledPackages -like '*atom*') {
        Write-Host 'Atom already installed.'
    }
    else {
        Write-Host 'Installing Atom.'
        choco install atom -y
    }
    
    if ($InstalledPackages -like '*gitkraken*') {
        Write-Host 'Git Kraken already installed.'
    }
    else {
        Write-Host 'Installing Git Kraken.'
        choco install gitkraken -y
    }
    
    if ($InstalledPackages -like '*Cmder*') {
        Write-Host 'Cmder already installed.'
    }
    else {
        Write-Host 'Installing Cmder.'
        choco install cmder -y
    }
    
    Write-Host 'Updating npm.'
    & "$($env:ProgramFiles)\nodejs\npm.cmd" install npm -g
}
else {
    Write-Warning -Message 'Chocolatey not installed.'
}