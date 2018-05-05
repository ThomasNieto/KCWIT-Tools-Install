#region Main
function Main {
    $Config = Get-Configuration
    
    if ($PSVersionTable.PSEdition -ne 'Core') {
        $OSArch = Get-CimInstance -ClassName Win32_OperatingSystem |
        Select-Object -ExpandProperty OSArchitecture
        
        $Config = $Config |
        Where-Object { $_.OperatingSystem -eq 'Windows' -and $_.OSArchitecture -eq $OSArch }
        
        $PSCorePath = Get-ChildItem -Path $env:ProgramFiles -Filter pwsh.exe -Recurse
        
        if (-not $PSCorePath) {
            Install-PSCore -PSCoreUri $Config.PSCoreUri
        }
        
        try {
            Start-Process -FilePath pwsh -ArgumentList "-File $($MyInvocation.MyCommand.Definition) -Verbose" -ErrorAction Stop
            exit
        }
        catch {
            exit 1
        }
    }
    
    if ($IsWindows) {
        $OSArch = Get-CimInstance -ClassName Win32_OperatingSystem |
        Select-Object -ExpandProperty OSArchitecture
        
        $Config = $Config |
        Where-Object { $_.OperatingSystem -eq 'Windows' -and $_.OSArchitecture -eq $OSArch }
    }
    elseif ($IsMacOS) {
        $Config = $Config |
        Where-Object { $_.OperatingSystem -eq 'MacOS' }
    }
    
    Install-Chrome -ChromeUri $Config.ChromeUri
    Install-NodeJs -NodeJsUri $Config.NodeJsUri
    Install-Atom -AtomUri $Config.AtomUri
    Install-Git -GitUri $Config.GitUri
    Install-GitKraken -GitKrakenUri $Config.GitKrakenUri
    
    Write-Verbose -Message 'Installation is complete.'
    exit
}
#endregion


#region Get-Configuration
function Get-Configuration {
    try {
        $ConfigPath = Join-Path -Path $PSScriptRoot -ChildPath 'KCWIT_ToolsInstall.xml' -ErrorAction Stop
        Import-Clixml -Path $ConfigPath -ErrorAction Stop
    }
    catch {
        Write-Warning -Message "Failed to import configuration file: $ConfigPath"
        exit 1
    }
}
#endregion


#region Install-PSCore
function Install-PSCore {
    param
    (
        [string]$PSCoreUri
    )
    
    Write-Verbose -Message 'Downloading PowerShell Core.'
    
    try {
        $PSCorePath = Join-Path -Path $env:TEMP -ChildPath PSCoreSetup.msi -ErrorAction Stop
        
        if (Get-Command -Name Invoke-WebRequest -ErrorAction SilentlyContinue) {
            Invoke-WebRequest -Uri $PSCoreUri -OutFile $PSCorePath -ErrorAction Stop
        }
        else {
            Invoke-WebFileDownload -Uri $PSCoreUri -Path $PSCorePath -ErrorAction Stop
        }
        
        Write-Verbose -Message 'Installing PowerShell Core.'
        $ExitCode = Install-Msi -Path $PSCorePath
    }
    catch {
        Write-Warning -Message 'Msiexec installer failed.'
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Verbose -Message 'PowerShell Core successfully installed.'
    }
    else {
        Write-Warning -Message 'PowerShell Core install failed.'
    }
}
#endregion


#region Install-Chrome
function Install-Chrome {
    param
    (
        [string]$ChromeUri
    )
    
    if ($IsWindows) {
        Write-Verbose -Message 'Checking for Google Chrome install.'
        $InstalledApplications = Get-CimInstance -ClassName Win32_Product
        
        if ($InstalledApplications | Where-Object -Property Name -Contains -Value 'Google Chrome') {
            Write-Verbose -Message 'Google Chrome already installed.'
        }
        else {
            Write-Verbose -Message 'Downloading Google Chrome.'
            
            try {
                $ChromePath = Join-Path -Path $env:TEMP -ChildPath ChromeSetup.msi -ErrorAction Stop
                Invoke-WebRequest -Uri $ChromeUri -OutFile $ChromePath -ErrorAction Stop
                Write-Verbose -Message 'Installing Google Chrome.'
                $ExitCode = Install-Msi -Path $ChromePath -ErrorAction Stop
            }
            catch {
                Write-Warning -Message 'Msiexec installer failed.'
            }
            
            if ($ExitCode -eq 0) {
                Write-Verbose -Message 'Google Chrome successfully installed.'
            }
            else {
                Write-Warning -Message 'Google Chrome install failed.'
            }
        }
    }
    elseif ($IsMacOS) {
        #TODO: MacOS install
    }
}
#endregion


#region Install-Git
function Install-Git {
    param
    (
        [string]$GitUri
    )
    
    if ($IsWindows) {
        if (Get-ItemProperty -Path HKLM:\SOFTWARE\GitForWindows) {
            Write-Verbose -Message 'Git already installed.'
        }
        else {
            Write-Verbose -Message 'Downloading Git.'
            
            $GitPath = Join-Path -Path $env:TEMP -ChildPath GitSetup.msi
            
            try {
                Invoke-WebRequest -Uri $NodeJsUri -OutFile $GitPath -ErrorAction Stop
                Write-Verbose -Message 'Installing Git.'
                $ExitCode = Install-Msi -Path $GitPath
            }
            catch {
                Write-Warning -Message 'Msiexec installer failed.'
            }
            
            if ($ExitCode -eq 0) {
                Write-Verbose -Message 'Git successfully installed.'
            }
            else {
                Write-Warning -Message 'Git install failed.'
            }
        }
    }
    elseif ($IsMacOS) {
        #TODO: MacOS install
    }
}
#endregion


#region Install-NodeJs
function Install-NodeJs {
    param
    (
        [string]$NodeJsUri
    )
    
    if ($IsWindows) {
        Write-Verbose -Message 'Checking for Node.js install.'
        $InstalledApplications = Get-CimInstance -ClassName Win32_Product
        
        if ($InstalledApplications | Where-Object -Property Name -Contains -Value 'Node.js') {
            Write-Verbose -Message 'Node.Js already installed.'
        }
        else {
            Write-Verbose -Message 'Downloading Node.Js.'
            
            $NodeJsPath = Join-Path -Path $env:TEMP -ChildPath NodeJsSetup.msi
            
            try {
                Invoke-WebRequest -Uri $NodeJsUri -OutFile $NodeJsPath -ErrorAction Stop
                Write-Verbose -Message 'Installing Node.Js.'
                $ExitCode = Install-Msi -Path $NodeJsPath
            }
            catch {
                Write-Warning -Message 'Msiexec installer failed.'
            }
            
            if ($ExitCode -eq 0) {
                Write-Verbose -Message 'Node.Js successfully installed.'
            }
            else {
                Write-Warning -Message 'Node.Js install failed.'
            }
        }
    }
    elseif ($IsMacOS) {
        #TODO: MacOS install
    }
}
#endregion


#region Update-Npm
function Update-Npm {
    Write-Verbose -Message 'Updating npm.'
    
    & "$($env:ProgramFiles)\nodejs\npm.cmd" install npm -g
    [version]$NpmVersion = & "$($env:ProgramFiles)\nodejs\npm.cmd" --version
    
    Write-Verbose -Message "Updated npm to version: $NpmVersion"
}
#endregion


#region Install-Atom
function Install-Atom {
    param
    (
        [string]$AtomUri
    )
    
    if ($IsWindows) {
        if (Get-ChildItem -Path $env:LOCALAPPDATA -Filter atom.exe -Recurse) {
            Write-Verbose -Message 'Atom already installed.'
        }
        else {
            Write-Verbose -Message 'Downloading Atom.'
            
            try {
                $AtomPath = Join-Path -Path $env:TEMP -ChildPath AtomSetup.exe -ErrorAction Stop
                Invoke-WebRequest -Uri $AtomUri -OutFile $AtomPath -ErrorAction Stop
                Write-Verbose -Message 'Installing Atom.'
                $ExitCode = Start-Process -FilePath $AtomPath -Wait
            }
            catch {
                Write-Warning -Message 'Installer failed.'
            }
            
            if ($ExitCode -eq 0) {
                Write-Verbose -Message 'Atom successfully installed.'
                
                Get-Process -Name atom | Stop-Process
            }
            else {
                Write-Warning -Message 'Atom install failed.'
            }
        }
    }
    elseif ($IsMacOS) {
        #TODO: MacOS install
    }
}
#endregion


#region Install-GitKraken
function Install-GitKraken {
    param
    (
        [string]$GitKrakenUri
    )
    
    if ($IsWindows) {
        if (Get-ChildItem -Path $env:LOCALAPPDATA -Filter gitkraken.exe -Recurse) {
            Write-Verbose -Message 'Git Kraken already installed.'
        }
        else {
            Write-Verbose -Message 'Downloading Git Kraken.'
            
            try {
                $GitKrakenPath = Join-Path -Path $env:TEMP -ChildPath GitKrakenSetup.exe -ErrorAction Stop
                Invoke-WebRequest -Uri $GitKrakenUri -OutFile $GitKrakenPath -ErrorAction Stop
                Write-Verbose -Message 'Installing Git Kraken.'
                $ExitCode = Start-Process -FilePath $GitKrakenPath -Wait
            }
            catch {
                Write-Warning -Message 'Installer failed.'
            }
            
            if ($ExitCode -eq 0) {
                Write-Verbose -Message 'Git Kraken successfully installed.'
                
                Get-Process -Name gitkraken | Stop-Process
            }
            else {
                Write-Warning -Message 'Git Kraken install failed.'
            }
        }
    }
    elseif ($IsMacOS) {
        #TODO: MacOS install
    }
}
#endregion


#region Invoke-WebFileDownload
function Invoke-WebFileDownload {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$URI,
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    begin {
        $WebClient = New-Object -TypeName System.Net.WebClient
    }
    process {
        Write-Verbose -Message "Downloading file from $URI to path: $Path"
        
        try {
            $WebClient.DownloadFile($URI, $Path)
        }
        catch {
            Write-Error -ErrorRecord $Error[0]
        }
    }
    end {
        Remove-Variable -Name WebClient
    }
}
#endregion


#region Install-Msi
function Install-Msi {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Position = 1)]
        [string]$ArgumentList = '/qn /norestart'
    )
    
    try {
        Start-Process -FilePath msiexec -ArgumentList "/i $Path $ArgumentList" -NoNewWindow -Wait -ErrorAction Stop
    }
    catch {
        Write-Error -ErrorRecord $Error[0]
    }
    
    Write-Output -InputObject $LASTEXITCODE
}
#endregion


Main